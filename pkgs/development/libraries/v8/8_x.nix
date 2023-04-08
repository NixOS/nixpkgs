{ stdenv, lib, fetchgit, fetchFromGitHub
, gn, ninja, python39, glib, pkg-config, icu
, xcbuild, darwin
, fetchpatch
}:

# Use update.sh to update all checksums.

let
  version = "8.8.278.14";
  v8Src = fetchgit {
    url = "https://chromium.googlesource.com/v8/v8";
    rev = version;
    sha256 = "0w6zldyas9w6p394876ssn3pnr5rjzjy1a5dcsmdkfj51m4rlg8m";
  };

  git_url = "https://chromium.googlesource.com";

  # This data is from the DEPS file in the root of a V8 checkout.
  deps = {
    "base/trace_event/common" = fetchgit {
      url    = "${git_url}/chromium/src/base/trace_event/common.git";
      rev    = "eb94f1c7aa96207f469008f29989a43feb2718f8";
      sha256 = "14gym38ncc9cysknv3jrql7jvcpjxf2d1dh4m8jgqb967jyzy5cj";
    };
    "build" = fetchgit {
      url    = "${git_url}/chromium/src/build.git";
      rev    = "2101eff1ac4bfd25f2dfa71ad632a600a38c1ed9";
      sha256 = "0i3xcwzi4pkv4xpgjkbmcpj5h6mji80zqskkx0jx3sx0ji63fylz";
    };
    "third_party/googletest/src" = fetchgit {
      url    = "${git_url}/external/github.com/google/googletest.git";
      rev    = "4fe018038f87675c083d0cfb6a6b57c274fb1753";
      sha256 = "1ilm9dmnm2v4y6l1wyfsajsbqv56j29ldfbpd0ykg4q90gpxz201";
    };
    "third_party/icu" = fetchgit {
      url    = "${git_url}/chromium/deps/icu.git";
      rev    = "c2a4cae149aae7fd30c4cbe3cf1b30df03b386f1";
      sha256 = "0lgzxf7hmfsgqazs74v5li9ifg8r0jx5m3gxh1mnw33vpwp7qqf4";
    };
    "third_party/zlib" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/zlib.git";
      rev    = "e84c9a3fd75fdc39055b7ae27d6ec508e50bd39e";
      sha256 = "03z30djnb3srhd0nvlxvx58sjqm2bvxk7j3vp4fk6h7a0sa2bdpi";
    };
    "third_party/jinja2" = fetchgit {
      url    = "${git_url}/chromium/src/third_party/jinja2.git";
      rev    = "a82a4944a7f2496639f34a89c9923be5908b80aa";
      sha256 = "02mkjwkrzhrg16zx97z792l0faz7gc8vga8w10r5y94p98jymnyz";
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
    rev = "53d92014bf94c3893886470a1c7c1289f8818db0";
    sha256 = "1xcm07qjk6m2czi150fiqqxql067i832adck6zxrishm70c9jbr9";
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

  env.NIX_CFLAGS_COMPILE = "-O2";
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
    homepage = "https://v8.dev/";
    description = "Google's open source JavaScript engine";
    maintainers = with maintainers; [ cstrahan proglodyte matthewbauer ];
    platforms = platforms.unix;
    license = licenses.bsd3;
    broken = stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12";
  };
}
