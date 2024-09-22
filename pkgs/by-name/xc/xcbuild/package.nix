{
  lib,
  cmake,
  darwin,
  fetchFromGitHub,
  libpng,
  libxml2,
  makeBinaryWrapper,
  ninja,
  stdenv,
  zlib,

  # These arguments are obsolete but required to avoid evaluation errors for now
  CoreGraphics ? null,
  CoreServices ? null,
  ImageIO ? null,
}:

let
  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "43359642a1c16ad3f4fc575c7edd0cb935810815";
    sha256 = "sha256-mKjXaawFHSRrbJBtADJ1Pdk6vtuD+ax0HFk6YaBSnXg=";
  };

  linenoise = fetchFromGitHub {
    owner = "antirez";
    repo = "linenoise";
    rev = "c894b9e59f02203dbe4e2be657572cf88c4230c3";
    sha256 = "sha256-nKxwWuSqr89lvI9Y3QAW5Mo7/iFfMNj/OOQVeA/FWnE=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xcbuild";

  outputs = [
    "out"
    "xcrun"
  ];

  # Once a version is released that includes
  # https://github.com/facebook/xcbuild/commit/183c087a6484ceaae860c6f7300caf50aea0d710,
  # we can stop doing this -pre thing.
  version = "0.1.2-pre";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "xcbuild";
    rev = "32b9fbeb69bfa2682bd0351ec2f14548aaedd554";
    sha256 = "1xxwg2849jizxv0g1hy0b1m3i7iivp9bmc4f5pi76swsn423d41m";
  };

  patches = [
    # Add missing header for `abort`
    ./patches/includes.patch
  ];

  prePatch = ''
    rmdir ThirdParty/*
    cp -r --no-preserve=all ${googletest} ThirdParty/googletest
    cp -r --no-preserve=all ${linenoise} ThirdParty/linenoise
  '';

  postPatch =
    lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      # Fix build on gcc-13 due to missing includes
      sed -e '1i #include <cstdint>' -i \
        Libraries/libutil/Headers/libutil/Permissions.h \
        Libraries/pbxbuild/Headers/pbxbuild/Tool/AuxiliaryFile.h \
        Libraries/pbxbuild/Headers/pbxbuild/Tool/Invocation.h

      # Avoid a glibc >= 2.25 deprecation warning that gets fatal via -Werror.
      sed 1i'#include <sys/sysmacros.h>' \
        -i Libraries/xcassets/Headers/xcassets/Slot/SystemVersion.h
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Apple Open Sourced LZFSE, but not libcompression, and it isn't
      # part of an impure framework we can add
      substituteInPlace Libraries/libcar/Sources/Rendition.cpp \
        --replace "#if HAVE_LIBCOMPRESSION" "#if 0"
    '';

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    ninja
  ];

  buildInputs = [
    libpng
    libxml2
    zlib
  ];

  # TODO: instruct cmake not to put it in /usr, rather than cleaning up
  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
    cp liblinenoise.* $out/lib/

    mkdir -p "$xcrun/bin"
    ln -s "$out/bin/xcrun" "$xcrun/bin/xcrun"

    # xcbuild and xcrun support absolute paths, but they can’t find the SDK with the way it’s set up in
    # the store. Fortunately, the combination of `DEVELOPER_DIR` and a plain `SDKROOT` is enough.
    wrapProgram "$out/bin/xcbuild" --set SDKROOT macosx
    wrapProgram "$out/bin/xcrun" --set SDKROOT macosx
  '';

  __structuredAttrs = true;

  passthru = {
    xcbuild = lib.warn "xcbuild.xcbuild is deprecated and will be removed; use xcbuild instead." finalAttrs.finalPackage;
  };

  meta = {
    description = "Xcode-compatible build tool";
    homepage = "https://github.com/facebook/xcbuild";
    license = with lib.licenses; [
      bsd2
      bsd3
    ];
    maintainers = lib.teams.darwin.members;
    platforms = lib.platforms.unix;
  };
})
