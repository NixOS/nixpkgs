{ stdenv, lib, fetchgit, fetchFromGitHub
, gn, ninja, python, glib, pkg-config, icu
, xcbuild, darwin
, fetchpatch
}:

let
  git_url = "https://chromium.googlesource.com";

  # This data is from the DEPS file in the root of a V8 checkout
  deps = {
    "base/trace_event/common" = fetchgit {
      url    = "${git_url}/chromium/src/base/trace_event/common.git";
      rev    = "dab187b372fc17e51f5b9fad8201813d0aed5129";
      sha256 = "0dmpj9hj4xv3xb0fl1kb9hm4bhpbs2s5csx3z8cgjd5vwvhdzig4";
    };
    build = fetchgit {
      url    = "${git_url}/chromium/src/build.git";
      rev    = "26e9d485d01d6e0eb9dadd21df767a63494c8fea";
      sha256 = "1jjvsgj0cs97d26i3ba531ic1f9gqan8x7z4aya8yl8jx02l342q";
    };
    "third_party/googletest/src" = fetchgit {
      url    = "${git_url}/external/github.com/google/googletest.git";
      rev    = "e3f0319d89f4cbf32993de595d984183b1a9fc57";
      sha256 = "18xz71l2xjrqsc0q317whgw4xi1i5db24zcj7v04f5g6r1hyf1a5";
    };
    "third_party/icu" = fetchgit {
      url    = "${git_url}/chromium/deps/icu.git";
      rev    = "f2223961702f00a8833874b0560d615a2cc42738";
      sha256 = "0z5p53kbrjfkjn0i12dpk55cp8976j2zk7a4wk88423s2c5w87zl";
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
    "third_party/zlib" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/zlib.git";
      rev    = "156be8c52f80cde343088b4a69a80579101b6e67";
      sha256 = "0hxbkkzmlv714fjq2jlp5dd2jc339xyh6gkjx1sz3srwv33mlk92";
    };
  };

in

stdenv.mkDerivation rec {
  pname = "v8";
  version = "8.4.255";

  doCheck = true;

  patches = [
    ./darwin.patch
    ./gcc_arm.patch  # Fix building zlib with gcc on aarch64, from https://gist.github.com/Adenilson/d973b6fd96c7709d33ddf08cf1dcb149
  ];

  src = fetchFromGitHub {
    owner = "v8";
    repo = "v8";
    rev = version;
    sha256 = "07ymw4kqbz7kv311gpk5bs5q90wj73n2q7jkyfhqk4hvhs1q5bw7";
  };

  postUnpack = ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: ''
        mkdir -p $sourceRoot/${n}
        cp -r ${v}/* $sourceRoot/${n}
      '') deps)}
    chmod u+w -R .
  '';

  postPatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace build/toolchain/linux/BUILD.gn \
      --replace 'toolprefix = "aarch64-linux-gnu-"' 'toolprefix = ""'
  '';

  gnFlags = [
    "use_custom_libcxx=false"
    "is_clang=${lib.boolToString stdenv.cc.isClang}"
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
  ] ++ lib.optional stdenv.cc.isClang ''clang_base_path="${stdenv.cc}"'';

  NIX_CFLAGS_COMPILE = "-O2";

  nativeBuildInputs = [ gn ninja pkg-config python ]
    ++ lib.optionals stdenv.isDarwin [ xcbuild darwin.DarwinTools ];
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
    EOF
  '';

  meta = with lib; {
    description = "Google's open source JavaScript engine";
    maintainers = with maintainers; [ cstrahan proglodyte matthewbauer ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
}
