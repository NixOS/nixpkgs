{ stdenv, lib, fetchgit, fetchFromGitHub
, gn, ninja, python39, glib, pkg-config, icu
, xcbuild, darwin
, fetchpatch
}:

# Use update.sh to update all checksums.

let
  version = "8.9.276";
  v8Src = fetchgit {
    url = "https://chromium.googlesource.com/v8/v8";
    rev = version;
    sha256 = "1npc84g8vdkgna3d9yhml7qsgqwvanigr4fm2aydcv90gkk509if";
  };

  git_url = "https://chromium.googlesource.com";

  # This data is from the DEPS file in the root of a V8 checkout.
  deps = {
    "base/trace_event/common" = fetchgit {
      url    = "${git_url}/chromium/src/base/trace_event/common.git";
      rev    = "9b27757731a454d6e76f3d1153ae62d603a16897";
      sha256 = "1zs9hvmc791b2g6ky7q0kmnk85cawkfzqxhi02373nh8y633a7my";
    };
    "build" = fetchgit {
      url    = "${git_url}/chromium/src/build.git";
      rev    = "d64e5999e338496041478aaed1759a32f2d2ff21";
      sha256 = "0290ki5hkwsr9idfaji0mpxy2gfzgv2kigqrhabvdr88f3mvnyc8";
    };
    "third_party/googletest/src" = fetchgit {
      url    = "${git_url}/external/github.com/google/googletest.git";
      rev    = "1b0cdaae57c046c87fb99cb4f69c312a7e794adb";
      sha256 = "0dmfv5wa03v3cy0vqz7xjpjqgphkhsyxdgrh3nvd69si7c7hk5k9";
    };
    "third_party/icu" = fetchgit {
      url    = "${git_url}/chromium/deps/icu.git";
      rev    = "899e18383fd732b47e6978db2b960a1b2a80179b";
      sha256 = "1n5x5mykg3dvywjqlyal50h39c6lnyqd0afl6rpfrzvcq9ivcsgj";
    };
    "third_party/zlib" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/zlib.git";
      rev    = "e84c9a3fd75fdc39055b7ae27d6ec508e50bd39e";
      sha256 = "03z30djnb3srhd0nvlxvx58sjqm2bvxk7j3vp4fk6h7a0sa2bdpi";
    };
    "third_party/jinja2" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/jinja2.git";
      rev    = "11b6b3e5971d760bd2d310f77643f55a818a6d25";
      sha256 = "1y1d7c0w0mbxhzh6bcjxs0x9viw7aipgazm10chcf9icaa4ygdff";
    };
    "third_party/markupsafe" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/markupsafe.git";
      rev    = "0944e71f4b2cb9a871bcbe353f95e889b64a611a";
      sha256 = "052ij8i7nkqchbvzv6ykj929hvfxjbzq7az2l01r0l2gfazhvdb9";
    };
  };

  # See `gn_version` in DEPS.
  gnSrc = fetchgit {
    url = "https://gn.googlesource.com/gn";
    rev = "595e3be7c8381d4eeefce62a63ec12bae9ce5140";
    sha256 = "08y7cjlgjdbzja5ij31wxc9i191845m01v1hc7y176svk9y0hj1d";
  };

  myGn = gn.overrideAttrs (oldAttrs: {
    version = "for-v8";
    src = gnSrc;
  });

in

stdenv.mkDerivation rec {
  pname = "v8";
  inherit version;

  doCheck = true;

  patches = [
    ./darwin.patch
  ];

  src = v8Src;

  postUnpack = ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: ''
        mkdir -p $sourceRoot/${n}
        cp -r ${v}/* $sourceRoot/${n}
      '') deps)}
    chmod u+w -R .
  '';

  postPatch = ''
    ${lib.optionalString stdenv.isAarch64 ''
      substituteInPlace build/toolchain/linux/BUILD.gn \
        --replace 'toolprefix = "aarch64-linux-gnu-"' 'toolprefix = ""'
    ''}
    ${lib.optionalString stdenv.isDarwin ''
      substituteInPlace build/config/compiler/compiler.gni \
        --replace 'strip_absolute_paths_from_debug_symbols = true' \
                  'strip_absolute_paths_from_debug_symbols = false'
      substituteInPlace build/config/compiler/BUILD.gn \
        --replace 'current_toolchain == host_toolchain || !use_xcode_clang' \
                  'false'
    ''}
    echo 'checkout_google_benchmark = false' > build/config/gclient_args.gni

    cp ${./gcc_toolchanin.gni} build/toolchain/gcc_toolchain.gni
  '';

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
  ] ++ lib.optional stdenv.cc.isClang ''clang_base_path="${stdenv.cc}"'';

  NIX_CFLAGS_COMPILE = "-O2";
  FORCE_MAC_SDK_MIN = stdenv.targetPlatform.sdkVer or "10.12";

  nativeBuildInputs = [
    myGn
    ninja
    pkg-config
    python39
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
    darwin.DarwinTools
    python39.pkgs.setuptools
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
    description = "Google's open source JavaScript engine";
    maintainers = with maintainers; [ cstrahan proglodyte matthewbauer ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
