{ stdenv, lib, fetchgit, fetchFromGitHub
, gn, ninja, python3, glib, pkg-config, icu
, xcbuild, darwin
, llvmPackages
, symlinkJoin
}:

# Use update.sh to update all checksums.

let
  version = "12.5.227.9";
  v8Src = fetchgit {
    url = "https://chromium.googlesource.com/v8/v8";
    rev = version;
    sha256 = "1c6wayriidnwnbsswjn5sn2slg2kfxc86s4mcqn049x3yyq8d32s";
  };

  git_url = "https://chromium.googlesource.com";

  # This data is from the DEPS file in the root of a V8 checkout.
  deps = {
    "base/trace_event/common" = fetchgit {
      url    = "${git_url}/chromium/src/base/trace_event/common.git";
      rev    = "29ac73db520575590c3aceb0a6f1f58dda8934f6";
      sha256 = "1c25i8gyz3z36gp192g3cshaj6rd6yxi6m7j8mhw7spaarprzq12";
    };
    "build" = fetchgit {
      url    = "${git_url}/chromium/src/build.git";
      rev    = "5fb1330b84e1ee6d5bda9bd11602087defc32cd9";
      sha256 = "0z7d46sdwmd3v32bydv50shfz8a0vk00987ar58mf9v2h3icpjw3";
    };
    "third_party/googletest/src" = fetchgit {
      url    = "${git_url}/external/github.com/google/googletest.git";
      rev    = "b1a777f31913f8a047f43b2a5f823e736e7f5082";
      sha256 = "1f9kz9wrsmc6kgifjdgkwllcv5bymkwzrlvapcxynzqcc0wzmx77";
    };
    "third_party/fuzztest" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/fuzztest.git";
      rev    = "ae21d2447b4b312ab22f7462c7f141caff4fa77a";
      sha256 = "1sy9an2qm72rwaydgckhcg83f6mwyfy5zbgnhsz5finp28h5a11j";
    };
    "third_party/icu" = fetchgit {
      url    = "${git_url}/chromium/deps/icu.git";
      rev    = "a622de35ac311c5ad390a7af80724634e5dc61ed";
      sha256 = "0maw8xbq20202sfm34jdlar4sz2yph28l6lhmlhccnfxn43528gp";
    };
    "third_party/zlib" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/zlib.git";
      rev    = "7d77fb7fd66d8a5640618ad32c71fdeb7d3e02df";
      sha256 = "1kicapnhky28qib3zyhlsasr00z1sn3n8kndi3h5b2llwcbkpgyb";
    };
    "third_party/jinja2" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/jinja2.git";
      rev    = "c9c77525ea20c871a1d4658f8d312b51266d4bad";
      sha256 = "1sk83hgp8cl8ndn7h7wdl9x47ajlr83pbfksn0v6i0xz3icg1ddz";
    };
    "third_party/markupsafe" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/markupsafe.git";
      rev    = "e582d7f0edb9d67499b0f5abd6ae5550e91da7f2";
      sha256 = "19g7amdyxfa047jznah87wmr19h9kxcmxvfp3zmb1ay5y2qwyld9";
    };
    "third_party/abseil-cpp" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/abseil-cpp.git";
      rev    = "a64dd87cec79c80c88190265cfea0cbd4027677f";
      sha256 = "06v7qglh6n7bcl83x97m79xrwbsck0jbgs081p46rdr3mk4nxjg2";
    };
    "third_party/fp16/src" = fetchgit {
      url    = "${git_url}/external/github.com/Maratyszcza/FP16.git";
      rev    = "581ac1c79dd9d9f6f4e8b2934e7a55c7becf0799";
      sha256 = "1kw3g0z8pbs2lnqm49r9r1z74ysxj9bklbnjdaymc39lgfvl3yg0";
    };
  };

  # See `gn_version` in DEPS.
  gnSrc = fetchgit {
    url = "https://gn.googlesource.com/gn";
    rev = "d823fd85da3fb83146f734377da454473b93a2b2";
    sha256 = "17bnivz3ndzhlph3h58mw5w23yrkp91zfj13a3pcpyfsl9pl1dcn";
  };

  myGn = gn.overrideAttrs (oldAttrs: {
    version = "for-v8";
    src = gnSrc;
  });

  xcbuild' = xcbuild.override {
    productBuildVer = "20A2408";
  };
in

stdenv.mkDerivation rec {
  pname = "v8";
  inherit version;

  doCheck = true;

  src = v8Src;

  postUnpack = ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: ''
        mkdir -p $sourceRoot/${n}
        cp -r ${v}/* $sourceRoot/${n}
      '') deps)}
    chmod u+w -R .
  '';

  patches = [
    ./llvm-17.patch
    ./disable-darwin-v8-system-instrumentation.patch
  ];

  postPatch = ''
    ${lib.optionalString stdenv.isAarch64 ''
      substituteInPlace build/toolchain/linux/BUILD.gn \
        --replace-fail 'toolprefix = "aarch64-linux-gnu-"' 'toolprefix = ""'
    ''}
    ${lib.optionalString stdenv.isDarwin ''
      substituteInPlace build/config/compiler/compiler.gni \
        --replace-fail 'strip_absolute_paths_from_debug_symbols = true' \
                  'strip_absolute_paths_from_debug_symbols = false'
    ''}
    ${lib.optionalString stdenv.isDarwin ''
      substituteInPlace build/config/compiler/BUILD.gn \
        --replace-fail "-Wl,-fatal_warnings" ""
    ''}
    touch build/config/gclient_args.gni
  '';

  llvmCcAndBintools = symlinkJoin { name = "llvmCcAndBintools"; paths = [ stdenv.cc llvmPackages.llvm ]; };

  gnFlags = [
    "use_custom_libcxx=false"
    "is_clang=${lib.boolToString stdenv.cc.isClang}"
    "use_sysroot=false"
    # "use_system_icu=true"
    "clang_use_chrome_plugins=false"
    "is_component_build=false"
    "v8_use_external_startup_data=false"
    "v8_monolithic=true"
    "is_debug=true"
    "is_official_build=false"
    "treat_warnings_as_errors=false"
    "v8_enable_i18n_support=true"
    "use_gold=false"
    # ''custom_toolchain="//build/toolchain/linux/unbundle:default"''
    ''host_toolchain="//build/toolchain/linux/unbundle:default"''
    ''v8_snapshot_toolchain="//build/toolchain/linux/unbundle:default"''
  ] ++ lib.optional stdenv.cc.isClang ''clang_base_path="${llvmCcAndBintools}"''
  ++ lib.optional stdenv.isDarwin ''use_lld=false'';

  env.NIX_CFLAGS_COMPILE = toString ([
    "-O2"
  ] ++ lib.optionals stdenv.cc.isClang [
    "-Wno-error=enum-constexpr-conversion"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    "-D__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__=101300"
  ]);
  FORCE_MAC_SDK_MIN = stdenv.hostPlatform.sdkVer or "10.12";

  nativeBuildInputs = [
    myGn
    ninja
    pkg-config
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild'
    llvmPackages.llvm
    python3.pkgs.setuptools
  ];
  buildInputs = [ glib icu ];

  ninjaFlags = [ ":d8" "v8_monolith" ];

  enableParallelBuilding = true;

  installPhase = ''
    install -D d8 $out/bin/d8
    install -D -m644 obj/libv8_monolith.a $out/lib/libv8.a
    install -D -m644 icudtl.dat $out/share/v8/icudtl.dat
    ln -s libv8.a $out/lib/libv8_monolith.a
    cp -r ../../include $out

    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/v8.pc << EOF
    Name: v8
    Description: V8 JavaScript Engine
    Version: ${version}
    Libs: -L$out/lib -lv8 -pthread
    Cflags: -I$out/include
    EOF
  '';

  meta = with lib; {
    homepage = "https://v8.dev/";
    description = "Google's open source JavaScript engine";
    mainProgram = "d8";
    maintainers = with maintainers; [ proglodyte matthewbauer ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
