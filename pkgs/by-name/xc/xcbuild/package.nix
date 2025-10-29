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

  # These are deprecated and do nothing. They’re needed for compatibility and will
  # warn eventually once in-tree uses are cleaned up.
  xcodePlatform ? null,
  xcodeVer ? null,
  sdkVer ? null,
  productBuildVer ? null,
}:

# TODO(@reckenrode) enable this warning after uses in nixpkgs have been fixed
#let
#  attrs = {
#    inherit
#      xcodePlatform
#      xcodeVer
#      sdkVer
#      productBuildVer
#      ;
#  };
#in
#assert lib.warnIf (lib.any (attr: attr != null) (lib.attrValues attrs)) ''
#  The following arguments are deprecated and do nothing: ${
#    lib.concatStringsSep ", " (lib.attrNames (lib.filterAttrs (_: value: value != null) attrs))
#  }
#
#  xcbuild will dynamically pick up the SDK and SDK version based
#  on the SDK used in nixpkgs. If you need to use a different SDK,
#  add the appropriate SDK to your package’s `buildInputs`.
#
#  See the stdenv documentation for how to use `apple-sdk`.
#'' true;

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

  version = "0.1.1-unstable-2019-11-20";
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "xcbuild";
    rev = "dbaee552d2f13640773eb1ad3c79c0d2aca7229c";
    hash = "sha256-7mvSuRCWU/LlIBdmnC59F4SSzJPEcQhlmEK13PNe1xc=";
  };

  patches = [
    # Add missing header for `abort`
    ./patches/includes.patch
    # Prevent xcrun from recursively invoking itself but still find native toolchain binaries
    ./patches/Use-system-toolchain-for-usr-bin.patch
    # Suppress warnings due to newer SDKs with unknown keys
    ./patches/Suppress-unknown-key-warnings.patch
    # Don't pipe stdout / stderr of processes launched by xcrun
    ./patches/fix-interactive-apps.patch
    # Fallback to $HOME and correctly handle missing home directories
    ./patches/fix-no-home-directory-crash.patch
  ];

  prePatch = ''
    rmdir ThirdParty/*
    cp -r --no-preserve=all ${googletest} ThirdParty/googletest
    cp -r --no-preserve=all ${linenoise} ThirdParty/linenoise
  '';

  postPatch = ''
    substituteInPlace Libraries/pbxbuild/Sources/Tool/TouchResolver.cpp \
      --replace-fail "/usr/bin/touch" "touch"
    substituteInPlace Libraries/pbxbuild/Sources/Tool/MakeDirectoryResolver.cpp \
      --replace-fail "/bin/mkdir" "mkdir"
    substituteInPlace Libraries/pbxbuild/Sources/Tool/SymlinkResolver.cpp \
      --replace-fail "/bin/ln" "ln"
    substituteInPlace Libraries/pbxbuild/Sources/Tool/ScriptResolver.cpp \
      --replace-fail "/bin/sh" "sh"
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
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

  # CMake 4 dropped support of versions lower than 3.5, and versions
  # lower than 3.10 are deprecated.
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

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
    xcbuild =
      # lib.warn "xcbuild.xcbuild is deprecated and will be removed; use xcbuild instead."
      finalAttrs.finalPackage;
  };

  meta = {
    description = "Xcode-compatible build tool";
    homepage = "https://github.com/facebook/xcbuild";
    license = with lib.licenses; [
      bsd2
      bsd3
    ];
    teams = [ lib.teams.darwin ];
    platforms = lib.platforms.unix;
  };
})
