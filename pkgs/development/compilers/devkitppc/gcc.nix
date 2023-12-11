{ stdenv
, callPackage
, lib
, applyPatches
, gmp, mpfr, libmpc
, texinfo
, devkitPPC-binutils
, devkitPPC-newlib
, lndir
, stage1 ? false
}:

let
  sources = callPackage ./sources.nix { };
in stdenv.mkDerivation rec {
  pname = "devkitPPC-gcc" + lib.optionalString stage1 "-stage1";
  src = sources.gcc;
  inherit (src) version;

  patches = [
    "${sources.buildscripts}/dkppc/patches/gcc-${version}.patch"
  ];

  nativeBuildInputs = [
    gmp mpfr libmpc
    texinfo
  ];

  buildInputs = [
    devkitPPC-binutils
  ];

  __structuredAttrs = true;

  hardeningDisable = [ "format" ];

  env = rec {
    gcc_cv_libc_provides_ssp = "yes";
    CFLAGS_FOR_TARGET = lib.concatStringsSep " " ([
      "-O2"
      "-ffunction-sections"
      "-fdata-sections"
      "-DCUSTOM_MALLOC_LOCK"
    ] ++ lib.optionals (!stage1) [
      "-isystem" "${lib.getLib devkitPPC-newlib}${devkitPPC-newlib.incdir}"
    ]);
    CXXFLAGS_FOR_TARGET = CFLAGS_FOR_TARGET;
    LDFLAGS_FOR_TARGET = lib.concatStringsSep " " ([
    ] ++ lib.optionals (!stage1) [
      "-L${lib.getLib devkitPPC-newlib}${devkitPPC-newlib.libdir}"
    ]);
  };

  configureFlags = [
    "--enable-languages=c,c++,objc,lto"
    "--enable-lto"
    "--with-cpu=750"
    "--disable-shared"
    "--enable-threads=dkp"
    "--disable-multilib"
    "--disable-libstdcxx-pch"
    "--disable-libstdcxx-verbose"
    "--enable-libstdcxx-time=yes"
    "--enable-libstdcxx-filesystem-ts"
    "--disable-tm-clone-registry"
    "--disable-__cxa_atexit"
    "--disable-libssp"
    "--enable-cxx-flags=-ffunction-sections -fdata-sections"
    "--target=${sources.target}"
    "--with-newlib"
    # FIXME do we want to leave this in?
    #"--with-bugurl=https://github.com/devkitpro/buildscripts/issues"
    "--with-pkgversion=devkitPPC release ${sources.buildscripts.version}"
  ] ++ lib.optionals stage1 [
    "--disable-nls"
  ];

  preConfigure = ''
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
  '';

  enableParallelBuilding = true;
  enableParallelInstalling = false;

  buildFlags = lib.optionals stage1 [ "all-gcc" ];
  installTargets = lib.optionals stage1 [ "install-gcc" ];

  postInstall = ''
    '${lndir}/bin/lndir' -silent '${devkitPPC-binutils}' "$out"
  '' + lib.optionalString (!stage1) ''
    '${lndir}/bin/lndir' -silent '${devkitPPC-newlib}' "$out"
  '';

  meta = {
    description = "GNU Compiler Collection (devkitPPC)";
    homepage = "https://gcc.gnu.org/";
    license = lib.licenses.gpl3Plus; # runtime support libraries are typically LGPLv3+
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.novenary ];
  };
}
