{ stdenv, lib, fetchgit
, gn, ninja, python3, glib, pkg-config, icu
, xcbuild, darwin
, fetchpatch
, llvmPackages
, symlinkJoin
}:

# Use update.sh to update all checksums.

let
  version = "9.7.106.18";
  v8Src = fetchgit {
    url = "https://chromium.googlesource.com/v8/v8";
    rev = version;
    sha256 = "0cb3w733w1xn6zq9dsr43nx6llcg9hrmb2dkxairarj9c0igpzyh";
  };

  git_url = "https://chromium.googlesource.com";

  # This data is from the DEPS file in the root of a V8 checkout.
  deps = {
    "base/trace_event/common" = fetchgit {
      url    = "${git_url}/chromium/src/base/trace_event/common.git";
      rev    = "7f36dbc19d31e2aad895c60261ca8f726442bfbb";
      sha256 = "01b2fhbxznqbakxv42ivrzg6w8l7i9yrd9nf72d6p5xx9dm993j4";
    };
    "build" = fetchgit {
      url    = "${git_url}/chromium/src/build.git";
      rev    = "cf325916d58a194a935c26a56fcf6b525d1e2bf4";
      sha256 = "1ix4h1cpx9bvgln8590xh7lllhsd9w1hd5k9l1gx5yxxrmywd3s4";
    };
    "third_party/googletest/src" = fetchgit {
      url    = "${git_url}/external/github.com/google/googletest.git";
      rev    = "16f637fbf4ffc3f7a01fa4eceb7906634565242f";
      sha256 = "11012k3c3mxzdwcw2iparr9lrckafpyhqzclsj26hmfbgbdi0rrh";
    };
    "third_party/icu" = fetchgit {
      url    = "${git_url}/chromium/deps/icu.git";
      rev    = "eedbaf76e49d28465d9119b10c30b82906e606ff";
      sha256 = "0mppvx7wf9zlqjsfaa1cf06brh1fjb6nmiib0lhbb9hd55mqjdjj";
    };
    "third_party/zlib" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/zlib.git";
      rev    = "6da1d53b97c89b07e47714d88cab61f1ce003c68";
      sha256 = "0v7ylmbwfwv6w6wp29qdf77kjjnfr2xzin08n0v1yvbhs01h5ppy";
    };
    "third_party/jinja2" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/jinja2.git";
      rev    = "ee69aa00ee8536f61db6a451f3858745cf587de6";
      sha256 = "1fsnd5h0gisfp8bdsfd81kk5v4mkqf8z368c7qlm1qcwc4ri4x7a";
    };
    "third_party/markupsafe" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/markupsafe.git";
      rev    = "1b882ef6372b58bfd55a3285f37ed801be9137cd";
      sha256 = "1jnjidbh03lhfaawimkjxbprmsgz4snr0jl06630dyd41zkdw5kr";
    };
  };

  # See `gn_version` in DEPS.
  gnSrc = fetchgit {
    url = "https://gn.googlesource.com/gn";
    rev = "8926696a4186279489cc2b8d768533e61bba73d7";
    sha256 = "1084lnyb0a1khbgjvak05fcx6jy973wqvsf77n0alxjys18sg2yk";
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

    # gcc-13 build fix for mixxign <cstdint> includes
    (fetchpatch {
      name = "gcc-13.patch";
      url  = "https://chromium.googlesource.com/v8/v8/+/c2792e58035fcbaa16d0cb70998852fbeb5df4cc^!?format=TEXT";
      decode = "base64 -d";
      hash = "sha256-hoPAkSaCmzXflPFXaKUwVPLECMpt6N6/8m8mBSTAHbU=";
    })
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
    ${lib.optionalString stdenv.isDarwin ''
      substituteInPlace build/config/compiler/BUILD.gn \
        --replace "-Wl,-fatal_warnings" ""
    ''}
    touch build/config/gclient_args.gni
    sed '1i#include <utility>' -i src/heap/cppgc/prefinalizer-handler.h # gcc12
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
  ]);
  FORCE_MAC_SDK_MIN = stdenv.hostPlatform.sdkVer or "10.12";

  nativeBuildInputs = [
    myGn
    ninja
    pkg-config
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
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
