{ stdenv, lib, fetchgit, fetchFromGitHub, gyp, readline, python, which, icu
, patchelf, coreutils
, doCheck ? false
}:

assert readline != null;

let
  arch = if stdenv.isArm
         then if stdenv.is64bit
              then"arm64"
              else "arm"
         else if stdenv.is64bit
              then"x64"
              else "ia32";
  git_url = "https://chromium.googlesource.com";
  clangFlag = if stdenv.isDarwin then "1" else "0";

  deps = {
    "build/gyp" = fetchgit {
      url = "${git_url}/external/gyp.git";
      rev = "5122240c5e5c4d8da12c543d82b03d6089eb77c5";
      sha256 = "0mdrrhmfl4jrdmfrxmg7ywhdf9c7gv2x08fiq955fs9z8kvxqgdx";
    };
    "third_party/icu" = fetchgit {
      url = "${git_url}/chromium/deps/icu.git";
      rev = "c81a1a3989c3b66fa323e9a6ee7418d7c08297af";
      sha256 = "0xrhig85vpw9hqjrhkxsr69m2xnig2bwmjhylzffrwz0783l7yhw";
    };
    "buildtools" = fetchgit {
      url = "${git_url}/chromium/buildtools.git";
      rev = "ecc8e253abac3b6186a97573871a084f4c0ca3ae";
      sha256 = "1ccfnj3dp4i0z2bj09zy8aa4x749id6h058qa330li368417jwci";
    };
    "testing/gtest" = fetchgit {
      url = "${git_url}/external/googletest.git";
      rev = "23574bf2333f834ff665f894c97bef8a5b33a0a9";
      sha256 = "1scyrk8d6xrsqma27q0wdrxqfa2n12k8mi9lfbsm5ivim9sr1d75";
    };
    "testing/gmock" = fetchgit {
      url = "${git_url}/external/googlemock.git";
      rev = "29763965ab52f24565299976b936d1265cb6a271";
      sha256 = "0n2ajjac7myr5bgqk0x7j8281b4whkzgr1irv5nji9n3xz5i6gz4";
    };
    "tools/clang" = fetchgit {
      url = "${git_url}/chromium/src/tools/clang.git";
      rev = "73ec8804ed395b0886d6edf82a9f33583f4a7902";
      sha256 = "0p2w4cgj3d4lqa8arss3j86lk0g8zhbbn5pzlcrhy5pl4xphjbk3";
    };
  };

in

stdenv.mkDerivation rec {
  name = "v8-${version}";
  version = "4.5.107";

  inherit doCheck;

  src = fetchFromGitHub {
    owner = "v8";
    repo = "v8";
    rev = version;
    sha256 = "0wbzi4rhm4ygsm1k4x0vwfm42z3j8ww6wz7bcvd0m7mqzayn0bw4";
  };

  postUnpack = ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: ''
        mkdir -p $sourceRoot/${n}
        cp -r ${v}/* $sourceRoot/${n}
      '') deps)}
  '';

  # Patches pulled from:
  # https://github.com/cowboyd/libv8/tree/4.5/patches
  patches = lib.optional (!doCheck) ./disable-building-tests.patch ++ [
    ./fPIC-for-static.patch
    ./build-standalone-static-library.patch
  ];

  postPatch = ''
    sed -i 's,#!/usr/bin/env python,#!${python}/bin/python,' build/gyp_v8
    sed -i 's,/bin/echo,${coreutils}/bin/echo,' build/standalone.gypi
    sed -i '/CR_CLANG_REVISION/ d' build/standalone.gypi
  '';

  configurePhase = ''
    PYTHONPATH="tools/generate_shim_headers:$PYTHONPATH" \
    PYTHONPATH="$(toPythonPath ${gyp}):$PYTHONPATH" \
      build/gyp_v8 \
        -f make \
        --generator-output="out" \
        -Dflock_index=0 \
        -Dclang=${clangFlag} \
        -Dv8_enable_i18n_support=1 \
        -Duse_system_icu=1 \
        -Dcomponent=shared_library \
        -Dconsole=readline \
        -Dv8_target_arch=${arch} \
        -Dv8_use_external_startup_data=0
  '';

  nativeBuildInputs = [ which ];
  buildInputs = [ readline python icu patchelf ];

  buildFlags = [
    "LINK=g++"
    "-C out"
    "builddir=$(CURDIR)/Release"
    "BUILDTYPE=Release"
  ];

  enableParallelBuilding = true;

  # the `libv8_libplatform` target is _only_ built as a static library,
  # and is expected to be statically linked in when needed.
  # see the following link for further commentary:
  # https://github.com/cowboyd/therubyracer/issues/391
  installPhase = ''
    install -vD out/Release/d8 "$out/bin/d8"
    install -vD out/Release/mksnapshot "$out/bin/mksnapshot"
    ${if stdenv.isDarwin then ''
    install -vD out/Release/lib.target/libv8.dylib "$out/lib/libv8.dylib"
    install_name_tool -change /usr/local/lib/libv8.dylib $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.cc.cc.lib}/lib/libgcc_s.1.dylib $out/bin/d8
    install_name_tool -id $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.cc.cc.lib}/lib/libgcc_s.1.dylib $out/lib/libv8.dylib
    '' else ''
    install -vD out/Release/lib.target/libv8.so "$out/lib/libv8.so"
    ''}
    mkdir -p "$out/include"
    cp -vr include/*.h "$out/include"
    cp -vr include/libplatform "$out/include"
    cp -v  out/Release/*.a "$out/lib"
  '';

  meta = with lib; {
    description = "Google's open source JavaScript engine";
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
