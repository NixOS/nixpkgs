{ stdenv, lib, fetchgit, fetchFromGitHub, gn, ninja, python, glib, pkgconfig
, doCheck ? false
, snapshot ? true
}:

let
  arch = if stdenv.isArm
         then if stdenv.is64bit
              then"arm64"
              else "arm"
         else if stdenv.is64bit
              then"x64"
              else "ia32";
  git_url = "https://chromium.googlesource.com";

  deps = {
    "base/trace_event/common" = fetchgit {
      url = "${git_url}/chromium/src/base/trace_event/common.git";
      rev = "65d1d42a5df6c0a563a6fdfa58a135679185e5d9";
      sha256 = "0ikk0dj12adzr0138jrmwzhx8n9sl5qzs86a3mc3gva08a8wc84p";
    };
    "build" = fetchgit {
      url = "${git_url}/chromium/src/build.git";
      rev = "48a2b7b39debc7c77c868c9ddb0a360af1ebc367";
      sha256 = "0aj554dfdbwnikwaapznfq55wkwbvg4114h7qamixy8ryjkaiy0k";
    };
    "buildtools" = fetchgit {
      url = "${git_url}/chromium/buildtools.git";
      rev = "5af0a3a8b89827a8634132080a39ab4b63dee489";
      sha256 = "1841803m40w1hmnmm7qzdpk4b6q1m8cb7q4hsflqfpddpf4lp3v1";
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
    "test/test262/data" = fetchgit {
      url = "${git_url}/external/github.com/tc39/test262.git";
      rev = "1b911a8f8abf4cb63882cfbe72dcd4c82bb8ad91";
      sha256 = "1hbp7vv41k7jka8azc78hhw4qng7gckr6dz1van7cyd067znwvr4";
    };
    "test/test262/harness" = fetchgit {
      url = "${git_url}/external/github.com/test262-utils/test262-harness-py.git";
      rev = "0f2acdd882c84cff43b9d60df7574a1901e2cdcd";
      sha256 = "00brj5avp43yamc92kinba2mg3a2x1rcd7wnm7z093l73idprvkp";
    };
    "test/wasm-js" = fetchgit {
      url = "${git_url}/external/github.com/WebAssembly/spec.git";
      rev = "17b4a4d98c80b1ec736649d5a73496a0e6d12d4c";
      sha256 = "03nyrrqffzj6xrmqi1v7f9m9395bdk53x301fy5mcq4hhpq6rsjr";
    };
    "testing/gmock" = fetchgit {
      url = "${git_url}/external/googlemock.git";
      rev = "0421b6f358139f02e102c9c332ce19a33faf75be";
      sha256 = "1xiky4v98maxs8fg1avcd56y0alv3hw8qyrlpd899zgzbq2k10pp";
    };
    "testing/gtest" = fetchgit {
      url = "${git_url}/external/github.com/google/googletest.git";
      rev = "6f8a66431cb592dad629028a50b3dd418a408c87";
      sha256 = "0bdba2lr6pg15bla9600zg0r0vm4lnrx0wqz84p376wfdxra24vw";
    };
    "third_party/icu" = fetchgit {
      url = "${git_url}/chromium/deps/icu.git";
      rev = "08cb956852a5ccdba7f9c941728bb833529ba3c6";
      sha256 = "0vn2iv068kmcjqqx5cgyha80x9iraz11hpx3q4n3rkvrlvbb3d7b";
    };
    "third_party/instrumented_libraries" = fetchgit {
      url = "${git_url}/chromium/src/third_party/instrumented_libraries.git";
      rev = "644afd349826cb68204226a16c38bde13abe9c3c";
      sha256 = "0d1vkwilgv1a4ghazn623gwmm7h51padpfi94qrmig1y748xfwfa";
    };
    # templates of code generator require jinja2 2.8 (while nixpkgs has 2.9.5, which breaks the template)
    "third_party/jinja2" = fetchgit {
      url = "${git_url}/chromium/src/third_party/jinja2.git";
      rev = "d34383206fa42d52faa10bb9931d6d538f3a57e0";
      sha256 = "0d9hyw0bvp3p0dbwy833cm9vdqxcam0qbm9jc561ynphddxlkmgd";
    };
    "third_party/markupsafe" = fetchgit {
      url = "${git_url}/chromium/src/third_party/markupsafe.git";
      rev = "8f45f5cfa0009d2a70589bcda0349b8cb2b72783";
      sha256 = "168ppjmicfdh4i1l0l25s86mdbrz9fgxmiq1rx33x79mph41scfz";
    };
    "tools/clang" = fetchgit {
      url = "${git_url}/chromium/src/tools/clang.git";
      rev = "40f69660bf3cd407e72b8ae240fdd6c513dddbfe";
      sha256 = "1plkb9dcn34yd6lad7w59s9vqwmcc592dasgdk232spkafpg8qcf";
    };
  };

in

stdenv.mkDerivation rec {
  name = "v8-${version}";
  version = "6.2.414.27";

  inherit doCheck;

  src = fetchFromGitHub {
    owner = "v8";
    repo = "v8";
    rev = version;
    sha256 = "15zrb9bcpnhljhrilqnjaak3a4xnhj8li6ra12g3gkrw3fzir9a2";
  };

  postUnpack = ''
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (n: v: ''
        mkdir -p $sourceRoot/${n}
        cp -r ${v}/* $sourceRoot/${n}
      '') deps)}
  '';

  prePatch = ''
    # use our gn, not the bundled one
    sed -i -e 's#gn_path = .*#gn_path = "${gn}/bin/gn"#' tools/mb/mb.py

    # disable tests
    if [ "$doCheck" = "" ]; then sed -i -e '/"test:gn_all",/d' BUILD.gn; fi

    # disable sysroot usage
    chmod u+w build/config build/config/sysroot.gni
    sed -i build/config/sysroot.gni \
        -e '/use_sysroot =/ { s#\(use_sysroot =\).*#\1 false#; :a  n; /current_cpu/ { s/^/#/; ba };  }'

    # patch shebangs (/usr/bin/env)
    patchShebangs tools/dev/v8gen.py
  '';

  configurePhase = ''
    tools/dev/v8gen.py -vv ${arch}.release -- \
        is_component_build=true \
        ${if snapshot then "v8_use_external_startup_data=false" else "v8_use_snapshot=false" } \
        is_clang=false \
        linux_use_bundled_binutils=false \
        treat_warnings_as_errors=false
  '';

  nativeBuildInputs = [ gn ninja pkgconfig ];
  buildInputs = [ python glib ];

  buildPhase = ''
    ninja -C out.gn/${arch}.release/
  '';

  enableParallelBuilding = true;

  installPhase = ''
    install -vD out.gn/${arch}.release/d8 "$out/bin/d8"
    install -vD out.gn/${arch}.release/mksnapshot "$out/bin/mksnapshot"
    mkdir -p "$out/lib"
    for f in libicui18n.so libicuuc.so libv8_libbase.so libv8_libplatform.so libv8.so; do
        install -vD out.gn/${arch}.release/$f "$out/lib/$f"
    done
    install -vD out.gn/${arch}.release/icudtl.dat "$out/lib/icudtl.dat"
    mkdir -p "$out/include"
    cp -vr include/*.h "$out/include"
    cp -vr include/libplatform "$out/include"
  '';

  meta = with lib; {
    description = "Google's open source JavaScript engine";
    maintainers = with maintainers; [ cstrahan proglodyte ];
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
