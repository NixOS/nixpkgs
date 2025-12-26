{
  lib,
  stdenv,
  gcc_meta,
  release_version,
  version,
  getVersionFile,
  monorepoSrc ? null,
  fetchpatch,
  autoreconfHook269,
  buildGccPackages,
  buildPackages,
  which,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libgcc";
  inherit version;

  src = monorepoSrc;

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
    buildGccPackages.libiberty
  ];

  nativeBuildInputs = [
    autoreconfHook269
    which
    python3
  ];

  patches = [
    (fetchpatch {
      name = "delete-MACHMODE_H.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/493aae4b034d62054d5e7e54dc06cd9a8be54e29.diff";
      hash = "sha256-oEk0lnI96RlpALWpb7J+GnrtgQsFVqDO57I/zjiqqTk=";
    })
    (fetchpatch {
      name = "custom-threading-model.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/e5d853bbe9b05d6a00d98ad236f01937303e40c4.diff";
      hash = "sha256-92LIttIXdh12/lRhivb2JTPpqUmGBRn+uKmR5pzuveo=";
      includes = [
        "config/*"
        "libgcc/configure.ac"
      ];
    })
    (fetchpatch {
      name = "no-pie-cflags.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/77144dd3b6736e0166156bb509590d924375a4f1.diff";
      hash = "sha256-QlxlTkWAK1dB7JiU5wz2iOW24gj3bFaeBpwb90oWwns=";
      includes = [
        "gcc/Makefile.in"
        "gcc/configure.ac"
        "libgcc/Makefile.in"
        "libgcc/configure.ac"
      ];
    })
    (fetchpatch {
      name = "no-target-system-root.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/9947930b7ae923010c5061fd8fa6b1ec4f22f161.diff";
      hash = "sha256-BZmpHpJuuyDmQMwpQhSgCZO0Rg7kXt8rTiJAT+e0sUw=";
    })
    (fetchpatch {
      name = "regular-libdir-includedir.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20250717174911.1536129-1-git@JohnEricson.me/raw";
      hash = "sha256-Cn7rvg1FI7H/26GzSe4pv5VW/gvwbwGqivAqEeawkwk=";
    })
    (getVersionFile "libgcc/force-regular-dirs.patch")
  ];

  autoreconfFlags = "--install --force --verbose . libgcc";

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  postPatch = ''
    sourceRoot=$(readlink -e "./libgcc")
  '';

  enableParallelBuilding = true;

  preConfigure = ''
    cd "$buildRoot"

    mkdir -p build-${stdenv.buildPlatform.config}/libiberty/
    cd build-${stdenv.buildPlatform.config}/libiberty/
    ln -s ${buildGccPackages.libiberty}/lib/libiberty.a ./

    mkdir -p "$buildRoot/gcc"
    cd "$buildRoot/gcc"

    (
    export AS_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$(basename $AS_FOR_BUILD)"}
    export CC_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$(basename $CC_FOR_BUILD)"}
    export CPP_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$(basename $CPP_FOR_BUILD)"}
    export CXX_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$(basename $CXX_FOR_BUILD)"}
    export LD_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc.bintools "$(basename $LD_FOR_BUILD)"}

    export AS=$AS_FOR_BUILD
    export CC=$CC_FOR_BUILD
    export CPP=$CPP_FOR_BUILD
    export CXX=$CXX_FOR_BUILD
    export LD=$LD_FOR_BUILD

    export AS_FOR_TARGET=${lib.getExe' stdenv.cc "$(basename $AS)"}
    export CC_FOR_TARGET=${lib.getExe' stdenv.cc "$(basename $CC)"}
    export CPP_FOR_TARGET=${lib.getExe' stdenv.cc "$(basename $CPP)"}
    export LD_FOR_TARGET=${lib.getExe' stdenv.cc.bintools "$(basename $LD)"}

    export NIX_CFLAGS_COMPILE_FOR_BUILD+=' -DGENERATOR_FILE=1'

    "$sourceRoot/../gcc/configure" $topLevelConfigureFlags

    sed -e 's,libgcc.mvars:.*$,libgcc.mvars:,' -i Makefile

    make \
      config.h \
      libgcc.mvars \
      tconfig.h \
      tm.h \
      options.h \
      insn-constants.h \
      version.h
    )
    mkdir -p "$buildRoot/gcc/include"

    mkdir -p "$buildRoot/gcc/${stdenv.hostPlatform.config}/libgcc"
    cd "$buildRoot/gcc/${stdenv.hostPlatform.config}/libgcc"
    configureScript=$sourceRoot/configure
    chmod +x "$configureScript"

    export AS_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$(basename $AS_FOR_BUILD)"}
    export CC_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$(basename $CC_FOR_BUILD)"}
    export CPP_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$(basename $CPP_FOR_BUILD)"}
    export CXX_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc "$(basename $CXX_FOR_BUILD)"}
    export LD_FOR_BUILD=${lib.getExe' buildPackages.stdenv.cc.bintools "$(basename $LD_FOR_BUILD)"}

    export AS=${lib.getExe' stdenv.cc "$(basename $AS)"}
    export CC=${lib.getExe' stdenv.cc "$(basename $CC)"}
    export CPP=${lib.getExe' stdenv.cc "$(basename $CPP)"}
    export CXX=${lib.getExe' stdenv.cc "$(basename $CXX)"}
    export LD=${lib.getExe' stdenv.cc.bintools "$(basename $LD)"}

    export AS_FOR_TARGET=${lib.getExe' stdenv.cc "$(basename $AS_FOR_TARGET)"}
    export CC_FOR_TARGET=${lib.getExe' stdenv.cc "$(basename $CC_FOR_TARGET)"}
    export CPP_FOR_TARGET=${lib.getExe' stdenv.cc "$(basename $CPP_FOR_TARGET)"}
    export LD_FOR_TARGET=${lib.getExe' stdenv.cc.bintools "$(basename $LD_FOR_TARGET)"}
  ''
  + lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE_OLD=$NIX_CFLAGS_COMPILE
    NIX_CFLAGS_COMPILE+=' -isystem ${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.config}/${version}/include-fixed'
  '';

  topLevelConfigureFlags = [
    "--build=${stdenv.buildPlatform.config}"
    "--host=${stdenv.buildPlatform.config}"
    "--target=${stdenv.hostPlatform.config}"

    "--disable-bootstrap"
    "--disable-multilib"
    "--enable-languages=c"

    "--disable-fixincludes"
    "--disable-intl"
    "--disable-lto"
    "--disable-libatomic"
    "--disable-libbacktrace"
    "--disable-libcpp"
    "--disable-libssp"
    "--disable-libquadmath"
    "--disable-libgomp"
    "--disable-libvtv"
    "--disable-vtable-verify"

    "--with-system-zlib"
  ]
  ++
    lib.optional (!stdenv.hostPlatform.isRiscV)
      # RISC-V does not like it being empty
      "--with-multilib-list="
  ++
    lib.optional (stdenv.hostPlatform.libc == "glibc")
      # Cheat and use previous stage's glibc to avoid infinite recursion. As
      # of GCC 11, libgcc only cares if the version is greater than 2.19,
      # which is quite ancient, so this little lie should be fine.
      "--with-glibc-version=${buildPackages.glibc.version}";

  configurePlatforms = [
    "build"
    "host"
  ];

  configureFlags = [
    "--disable-dependency-tracking"
    "gcc_cv_target_thread_file=single"
    # $CC cannot link binaries, let alone run then
    "cross_compiling=true"
    # Do not have dynamic linker without libc
    "--enable-static"
    "--disable-shared"
  ];

  # Set the variable back the way it was, see corresponding code in
  # `preConfigure`.
  postConfigure = lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE=$NIX_CFLAGS_COMPILE_OLD
  '';

  makeFlags = [ "MULTIBUILDTOP:=../" ];

  postInstall = ''
    install -c -m 644 gthr-default.h "$dev/include"
  '';

  doCheck = true;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/";
  };
})
