{ stdenv, lib, fetchgit, fetchFromGitHub, gyp, readline, python, which, icu
, patchelf, coreutils, cctools
, doCheck ? false
, static ? false
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
  sharedFlag = if static then "static_library" else "shared_library";

  deps = {
    "build" = fetchgit {
      url = "${git_url}/chromium/src/build.git";
      rev = "2c67d4d74b6b3673228fab191918500a582ef3b0";
      sha256 = "0jc7hci5yh792pw0ahjfxrk5xzllnlrv9llmwlgcgn2x8x6bn34q";
    };
    "tools/gyp" = fetchgit {
      url = "${git_url}/external/gyp.git";
      rev = "e7079f0e0e14108ab0dba58728ff219637458563";
      sha256 = "0yd1ds13z0r9d2sb67f9i1gjn1zgzwyfv96qqqp6pn5pcfbialg6";
    };
    "third_party/icu" = fetchgit {
      url = "${git_url}/chromium/deps/icu.git";
      rev = "b5ecbb29a26532f72ef482569b223d5a51fd50bf";
      sha256 = "0ld47wdnk8grcba221z67l3pnphv9zwifk4y44f5b946w3iwmpns";
    };
    "buildtools" = fetchgit {
      url = "${git_url}/chromium/buildtools.git";
      rev = "60f7f9a8b421ebf9a46041dfa2ff11c0fe59c582";
      sha256 = "0i10bw7yhslklqwcx5krs3k05sicb73cpwd0mkaz96yxsvmkvjq0";
    };
    "base/trace_event/common" = fetchgit {
      url = "${git_url}/chromium/src/base/trace_event/common.git";
      rev = "315bf1e2d45be7d53346c31cfcc37424a32c30c8";
      sha256 = "1pp2ygvp20j6g4868hrmiw0j704kdvsi9d9wx2gbk7w79rc36695";
    };
    "platform/inspector_protocol" = fetchgit {
      url = "${git_url}/chromium/src/third_party/WebKit/Source/platform/inspector_protocol.git";
      rev = "f49542089820a34a9a6e33264e09b73779407512";
      sha256 = "1lwpass3p4rpp2kjmxxxpkqyv4lznxhf4i0yy7mmrd7jkpc7kn8k";
    };
    "tools/mb" = fetchgit {
      url = "${git_url}/chromium/src/tools/mb.git";
      rev = "0c4dc43c454f26936ddf3074ab8e9a41e3dc03a3";
      sha256 = "0f96qphbmwn1pprv0a6xf68p01s1jzx2sz6pmadqbrs1dgh1xwnk";
    };
    "tools/swarming_client" = fetchgit {
      url = "${git_url}/external/swarming.client.git";
      rev = "7f63a272f7d9785ce41b6d10bb3106c49a968e57";
      sha256 = "1pmb8bq4qifjf2dzz8c4jdwhlvwgrl9ycjaalcyh1sbh4lx3yvv2";
    };
    "testing/gtest" = fetchgit {
      url = "${git_url}/external/github.com/google/googletest.git";
      rev = "6f8a66431cb592dad629028a50b3dd418a408c87";
      sha256 = "0bdba2lr6pg15bla9600zg0r0vm4lnrx0wqz84p376wfdxra24vw";
    };
    "testing/gmock" = fetchgit {
      url = "${git_url}/external/googlemock.git";
      rev = "0421b6f358139f02e102c9c332ce19a33faf75be";
      sha256 = "1xiky4v98maxs8fg1avcd56y0alv3hw8qyrlpd899zgzbq2k10pp";
    };
    "test/benchmarks/data" = fetchgit {
      url = "${git_url}/v8/deps/third_party/benchmarks.git";
      rev = "05d7188267b4560491ff9155c5ee13e207ecd65f";
      sha256 = "0ad2ay14bn67d61ks4dmzadfnhkj9bw28r4yjdjjyzck7qbnzchl";
    };
    "test/mozilla/data" = fetchgit {
      url = "${git_url}/v8/deps/third_party/mozilla-tests.git";
      rev = "f6c578a10ea707b1a8ab0b88943fe5115ce2b9be";
      sha256 = "0rfdan76yfawqxbwwb35aa57b723j3z9fx5a2w16nls02yk2kqyn";
    };
    "test/simdjs/data" = fetchgit {
      url = "${git_url}/external/github.com/tc39/ecmascript_simd.git";
      rev = "baf493985cb9ea7cdbd0d68704860a8156de9556";
      sha256 = "178r0k40a58c1187gfzqz2i6as34l8cliy1g1x870wyy0qcvlq2q";
    };
    "test/test262/data" = fetchgit {
      url = "${git_url}/external/github.com/tc39/test262.git";
      rev = "88bc7fe7586f161201c5f14f55c9c489f82b1b67";
      sha256 = "0gc7fmaqrgwb6rl02jnrm3synpwzzg0dfqy3zm386r1qcisl93xs";
    };
    "test/test262/harness" = fetchgit {
      url = "${git_url}/external/github.com/test262-utils/test262-harness-py.git";
      rev = "cbd968f54f7a95c6556d53ba852292a4c49d11d8";
      sha256 = "094c3600a4wh1m3fvvlivn290kik1pzzvwabq77lk8bh4jkkv7ki";
    };
    "tools/clang" = fetchgit {
      url = "${git_url}/chromium/src/tools/clang.git";
      rev = "496622ab4aaa5be7e5a9b80617013cb02f45dc87";
      sha256 = "1gkhk2bzpxwzkirzcqfixxpprbr8mn6rk00krm25daarm3smydmf";
    };
  };

in

stdenv.mkDerivation rec {
  name = "v8-${version}";
  version = "5.4.232";

  inherit doCheck;

  src = fetchFromGitHub {
    owner = "v8";
    repo = "v8";
    rev = version;
    sha256 = "1nqxbkz75m8xrjih0sj3f3iqvif4192vxdaxzy8r787rihjwg9nx";
  };

  postUnpack = ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: ''
        mkdir -p $sourceRoot/${n}
        cp -r ${v}/* $sourceRoot/${n}
      '') deps)}
  '';

  # Patch based off of:
  # https://github.com/cowboyd/libv8/tree/v5.1.281.67.0/patches
  patches = lib.optional (!doCheck) ./libv8-5.4.232.patch
  ++ stdenv.lib.optionals stdenv.isDarwin [ ./no-xcode.patch ];

  prePatch = ''
    chmod +w tools/gyp/pylib/gyp
    chmod +w tools/gyp/pylib/gyp/xcode_emulation.py
  '';

  postPatch = ''
    sed -i 's,#!/usr/bin/env python,#!${python}/bin/python,' gypfiles/gyp_v8
    sed -i 's,/bin/echo,${coreutils}/bin/echo,' gypfiles/standalone.gypi
    sed -i '/CR_CLANG_REVISION/ d' gypfiles/standalone.gypi
    sed -i 's/-Wno-format-pedantic//g' gypfiles/standalone.gypi
  '';

  configurePhase = ''
    PYTHONPATH="tools/generate_shim_headers:$PYTHONPATH" \
    PYTHONPATH="$(toPythonPath ${gyp}):$PYTHONPATH" \
      gypfiles/gyp_v8 \
        -f make \
        --generator-output="out" \
        -Dflock_index=0 \
        -Dclang=${clangFlag} \
        -Dv8_enable_i18n_support=1 \
        -Duse_system_icu=1 \
        -Dcomponent=${sharedFlag} \
        -Dconsole=readline \
        -Dv8_target_arch=${arch} \
        -Dv8_use_external_startup_data=0
  '';

  nativeBuildInputs = [ which ];
  buildInputs = [ readline python icu patchelf ]
  ++ stdenv.lib.optionals stdenv.isDarwin [ cctools ];

  NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  buildFlags = [
    "LINK=c++"
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
    ${if static then ""
    else if stdenv.isDarwin then ''
    install -vD out/Release/libv8.dylib "$out/lib/libv8.dylib"
    install_name_tool -change /usr/local/lib/libv8.dylib $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.cc.cc.lib}/lib/libgcc_s.1.dylib $out/bin/d8
    install_name_tool -id $out/lib/libv8.dylib -change /usr/lib/libgcc_s.1.dylib ${stdenv.cc.cc.lib}/lib/libgcc_s.1.dylib $out/lib/libv8.dylib
    '' else ''
    install -vD out/Release/lib.target/libv8.so "$out/lib/libv8.so"
    ''}
    mkdir -p "$out/include"
    cp -vr include/*.h "$out/include"
    cp -vr include/libplatform "$out/include"
    mkdir -p "$out/lib"
    cp -v  out/Release/*.a "$out/lib"
  '';

  meta = with lib; {
    description = "Google's open source JavaScript engine";
    maintainers = with maintainers; [ cstrahan proglodyte ];
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
  };
}
