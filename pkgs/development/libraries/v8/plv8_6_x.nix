# NOTE: this expression is NOT exported from the top-level of all-packages.nix,
# it is exclusively used by the 'plv8' PostgreSQL extension.
# Since plv8 2.3.2, plv8 no longer requires this specific version, but as of
# 2019-08-29, nixpkgs does not have v8 6.x, and v8_5 is bumped to 5.4.232, which
# is a bit outdated.  plv8 3.x is planned to support v8 7.x

{ stdenv, lib, fetchgit, fetchFromGitHub, gn, ninja, python, glib, pkgconfig
, doCheck ? false
, snapshot ? true
}:

let
  arch = if stdenv.isAarch32
         then if stdenv.is64bit
              then"arm64"
              else "arm"
         else if stdenv.is64bit
              then"x64"
              else "ia32";
  git_url = "https://chromium.googlesource.com";

  # This data is from the DEPS file in the root of a V8 checkout
  deps = {
    "base/trace_event/common" = fetchgit {
      url    = "${git_url}/chromium/src/base/trace_event/common.git";
      rev    = "0e9a47d74970bee1bbfc063c47215406f8918699";
      sha256 = "07rbzrlscp8adh4z86yl5jxdnvgkc3xs950xldpk318wf9i3bh6c";
    };
    "build" = fetchgit {
      url    = "${git_url}/chromium/src/build.git";
      rev    = "9338ce52d0b9bcef34c38285fbd5023b62739fac";
      sha256 = "1s2sa8dy3waidsirjylc82ggb18l1108bczjc8z0v4ywyj4k0cvh";
    };
    "buildtools" = fetchgit {
      url    = "${git_url}/chromium/buildtools.git";
      rev    = "505de88083136eefd056e5ee4ca0f01fe9b33de8";
      sha256 = "0vj216nhb803bggsl0hnyagj8njrm96pn8sim6xcnqb7nhz1vabw";
    };
    "test/benchmarks/data" = fetchgit {
      url    = "${git_url}/v8/deps/third_party/benchmarks.git";
      rev    = "05d7188267b4560491ff9155c5ee13e207ecd65f";
      sha256 = "0ad2ay14bn67d61ks4dmzadfnhkj9bw28r4yjdjjyzck7qbnzchl";
    };
    "test/mozilla/data" = fetchgit {
      url    = "${git_url}/v8/deps/third_party/mozilla-tests.git";
      rev    = "f6c578a10ea707b1a8ab0b88943fe5115ce2b9be";
      sha256 = "0rfdan76yfawqxbwwb35aa57b723j3z9fx5a2w16nls02yk2kqyn";
    };
    "test/test262/data" = fetchgit {
      url    = "${git_url}/external/github.com/tc39/test262.git";
      rev    = "5d4c667b271a9b39d0de73aef5ffe6879c6f8811";
      sha256 = "0q9iwb2nkybf9np95wgf5m372aw2lhx9wlsw41a2a80kbkvb2kqg";
    };
    "test/test262/harness" = fetchgit {
      url    = "${git_url}/external/github.com/test262-utils/test262-harness-py.git";
      rev    = "0f2acdd882c84cff43b9d60df7574a1901e2cdcd";
      sha256 = "00brj5avp43yamc92kinba2mg3a2x1rcd7wnm7z093l73idprvkp";
    };
    "test/wasm-js" = fetchgit {
      url    = "${git_url}/external/github.com/WebAssembly/spec.git";
      rev    = "a7e226a92e660a3d5413cfea4269824f513259d2";
      sha256 = "0z3aybj3ykajwh2bv5fwd6pwqjjsq8dnwrqc2wncb6r9xcjwbgxp";
    };
    "testing/gtest" = fetchgit {
      url    = "${git_url}/external/github.com/google/googletest.git";
      rev    = "6f8a66431cb592dad629028a50b3dd418a408c87";
      sha256 = "0bdba2lr6pg15bla9600zg0r0vm4lnrx0wqz84p376wfdxra24vw";
    };
    "third_party/icu" = fetchgit {
      url    = "${git_url}/chromium/deps/icu.git";
      rev    = "741688ebf328da9adc52505248bf4e2ef868722c";
      sha256 = "02ifm18qjlrkn5nm2rxkf9yz9bdlyq7c65jfjndv63vi1drqh1r9";
    };
    "third_party/instrumented_libraries" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/instrumented_libraries.git";
      rev    = "28417458ac4dc79f68915079d0f283f682504cc0";
      sha256 = "1qf5c2946n37p843yriv7xawi6ss6samabghq43s49cgd4wq8dc3";
    };
    "third_party/jinja2" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/jinja2.git";
      rev    = "d34383206fa42d52faa10bb9931d6d538f3a57e0";
      sha256 = "0d9hyw0bvp3p0dbwy833cm9vdqxcam0qbm9jc561ynphddxlkmgd";
    };
    "third_party/markupsafe" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/markupsafe.git";
      rev    = "8f45f5cfa0009d2a70589bcda0349b8cb2b72783";
      sha256 = "168ppjmicfdh4i1l0l25s86mdbrz9fgxmiq1rx33x79mph41scfz";
    };
    "tools/clang" = fetchgit {
      url    = "${git_url}/chromium/src/tools/clang.git";
      rev    = "8688d267571de76a56746324dcc249bf4232b85a";
      sha256 = "0krq4zz1vnwp064bm517gwr2napy18wyccdh8w5s4qgkjwwxd63s";
    };
    "tools/gyp" = fetchgit {
      url    = "${git_url}/external/gyp.git";
      rev    = "d61a9397e668fa9843c4aa7da9e79460fe590bfb";
      sha256 = "1z081h72mjy285jb1kj5xd0pb4p12n9blvsimsavyn3ldmswv0r0";
    };
    "tools/luci-go" = fetchgit {
      url    = "${git_url}/chromium/src/tools/luci-go.git";
      rev    = "45a8a51fda92e123619a69e7644d9c64a320b0c1";
      sha256 = "0r7736gqk7r0i7ig0b5ib10d9q8a8xzsmc0f0fbkm9k78v847vpj";
    };
    "tools/swarming_client" = fetchgit {
      url    = "${git_url}/infra/luci/client-py.git";
      rev    = "4bd9152f8a975d57c972c071dfb4ddf668e02200";
      sha256 = "03zk91gzvqv01g1vbl8d7h8al7vs4ymrrdc8ipg9wpq52yh65smh";
    };
  };

in

stdenv.mkDerivation rec {
  pname = "v8";
  version = "6.4.388.40";

  inherit doCheck;

  src = fetchFromGitHub {
    owner = "v8";
    repo = "v8";
    rev = version;
    sha256 = "1lq239cgqyidrynz8g3wbdv70ymzv6s0ppad8s219gb3jnizm16a";
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
        is_component_build=true               \
        ${if snapshot then "v8_use_external_startup_data=false" else "v8_use_snapshot=false"} \
        is_clang=false                        \
        linux_use_bundled_binutils=false      \
        treat_warnings_as_errors=false        \
        use_custom_libcxx=false               \
        use_custom_libcxx_for_host=false
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
