{ stdenv, lib, fetchgit, fetchFromGitHub
, gn, ninja, python, glib, pkgconfig, icu
, xcbuild, darwin
, fetchpatch
}:

let
  git_url = "https://chromium.googlesource.com";

  # This data is from the DEPS file in the root of a V8 checkout
  deps = {
    "base/trace_event/common" = fetchgit {
      url    = "${git_url}/chromium/src/base/trace_event/common.git";
      rev    = "936ba8a963284a6b3737cf2f0474a7131073abee";
      sha256 = "14nr22fqdpxma1kzjflj6a865vr3hfnnm2gs4vcixyq4kmfzfcy2";
    };
    build = fetchgit {
      url    = "${git_url}/chromium/src/build.git";
      rev    = "325e95d6dae64f35b160b3dc7d73218cee5ec079";
      sha256 = "0dddyxa76p2xpjhmxif05v63i5ar6h5v684fdl667sg84f5bhhxf";
    };
    "third_party/googletest/src" = fetchgit {
      url    = "${git_url}/external/github.com/google/googletest.git";
      rev    = "5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081";
      sha256 = "0gmr10042c0xybxnn6g7ndj1na1mmd3l9w7449qlcv4s8gmfs7k6";
    };
    "third_party/icu" = fetchgit {
      url    = "${git_url}/chromium/deps/icu.git";
      rev    = "960f195aa87acaec46e6104ec93a596da7ae0843";
      sha256 = "073kh6gpcairgjxf3hlhpqljc13gwl2aj8fz91fv220xibwqs834";
    };
    "third_party/jinja2" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/jinja2.git";
      rev    = "b41863e42637544c2941b574c7877d3e1f663e25";
      sha256 = "1qgilclkav67m6cl2xq2kmzkswrkrb2axc2z8mw58fnch4j1jf1r";
    };
    "third_party/markupsafe" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/markupsafe.git";
      rev    = "8f45f5cfa0009d2a70589bcda0349b8cb2b72783";
      sha256 = "168ppjmicfdh4i1l0l25s86mdbrz9fgxmiq1rx33x79mph41scfz";
    };
  };

in

stdenv.mkDerivation rec {
  pname = "v8";
  version = "7.4.255";

  doCheck = true;

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/RPi-Distro/chromium-browser/master/debian/patches/revert-Xclang-instcombine-lower-dbg-declare.patch";
      sha256 = "02hczcg43m36q8j1kv5j3hq9czj9niiil9w13w22vzv2f3c67dvn";
    })
    ./darwin.patch
  ];

  src = fetchFromGitHub {
    owner = "v8";
    repo = "v8";
    rev = version;
    sha256 = "14i0c71hmffzqnq9n73dh9dnabdxhbjhzkhqpk5yv9y90bwrzi2n";
  };

  postUnpack = ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: ''
        mkdir -p $sourceRoot/${n}
        cp -r ${v}/* $sourceRoot/${n}
      '') deps)}
    chmod u+w -R .
  '';

  postPatch = stdenv.lib.optionalString stdenv.isAarch64 ''
    substituteInPlace build/toolchain/linux/BUILD.gn \
      --replace 'toolprefix = "aarch64-linux-gnu-"' 'toolprefix = ""'
  '';

  gnFlags = [
    "use_custom_libcxx=false"
    "is_clang=${if stdenv.cc.isClang then "true" else "false"}"
    "use_sysroot=false"
    # "use_system_icu=true"
    "is_component_build=false"
    "v8_use_external_startup_data=false"
    "v8_monolithic=true"
    "is_debug=true"
    "is_official_build=false"
    "treat_warnings_as_errors=false"
    "v8_enable_i18n_support=true"
    "use_gold=false"
    "use_system_xcode=true"
    # ''custom_toolchain="//build/toolchain/linux/unbundle:default"''
    ''host_toolchain="//build/toolchain/linux/unbundle:default"''
    ''v8_snapshot_toolchain="//build/toolchain/linux/unbundle:default"''
  ] ++ stdenv.lib.optional stdenv.cc.isClang ''clang_base_path="${stdenv.cc}"'';

  # with gcc8, -Wclass-memaccess became part of -Wall and causes logging limit
  # to be exceeded
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isGNU "-Wno-class-memaccess";

  nativeBuildInputs = [ gn ninja pkgconfig python ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ xcbuild darwin.DarwinTools ];
  buildInputs = [ glib icu ];

  ninjaFlags = [ ":d8" "v8_monolith" ];

  enableParallelBuilding = true;

  installPhase = ''
    install -D d8 $out/bin/d8
    install -D obj/libv8_monolith.a $out/lib/libv8.a
    cp -r ../../include $out

    mkdir -p $out/lib/pkgconfig
    cat > $out/lib/pkgconfig/v8.pc << EOF
    Name: v8
    Description: V8 JavaScript Engine
    Version: ${version}
    Libs: -L$out/lib -lv8 -pthread
    Cflags: -I$out/include
    Libs: -L$out/lib -lpulse
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
