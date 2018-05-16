{ stdenv, targetPackages, fetchurl, targetPlatform, hostPlatform
, langC ? true, langCC ? true, langFortran ? false
, langObjC ? targetPlatform.isDarwin
, langObjCpp ? targetPlatform.isDarwin
, langJava ? false
, langGo ? false
# build deps
, gmp, mpfr, libmpc
, extraBuildInputs ? []
, extraConfigureFlags ? []
, ... }:

with stdenv.lib;

let version = "7.3.0";
in stdenv.mkDerivation ({

  name = "gcc-${version}-prebuilt" + optionalString (targetPlatform != hostPlatform) "-${targetPlatform.config}";

  src = fetchurl {
    url = "mirror://gcc/releases/gcc-${version}/gcc-${version}.tar.xz";
    sha256 = "0p71bij6bfhzyrs8676a8jmpjsfz392s2rg862sdnsk30jpacb43";
  };

  buildInputs = [
    gmp mpfr libmpc #libelf
    stdenv.cc.bintools # For linking code at run-time
  ] ++ extraBuildInputs;

  configurePlatforms = [ "build" "host" ] ++ optional (targetPlatform != hostPlatform) "target";

  configureFlags = [
    "--enable-languages=${
        concatStrings (intersperse ","
          (  optional langC        "c"
          ++ optional langCC       "c++"
          ++ optional langFortran  "fortran"
          ++ optional langJava     "java"
          ++ optional langGo       "go"
          ++ optional langObjC     "objc"
          ++ optional langObjCpp   "obj-c++"
          )
        )
      }"
      "--disable-multilib"
      "--with-bugurl=https://github.com/nixos/nixpkgs/issues"
      "--with-gmp-include=${gmp.dev}/include"
      "--with-gmp-lib=${gmp.out}/lib"
      "--with-mpfr-include=${mpfr.dev}/include"
      "--with-mpfr-lib=${mpfr.out}/lib"
      "--with-mpc=${libmpc}"

      "--with-threads=posix"

      # we need to ensure that we set the proper assembler and linker. If we don't
      # we can't change this at runtime anymore -- m(
      "--with-as=${targetPackages.stdenv.cc.bintools}/bin/${targetPlatform.config}-as"
      "--with-ld=${targetPackages.stdenv.cc.bintools}/bin/${targetPlatform.config}-ld"
    ] ++ extraConfigureFlags;

  # don't fail with: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  makeFlags = [ "all-gcc" ];
  # installTargets = "install-${component}";
  installPhase = "mkdir -p $out && tar -czf $out/prebuilt.tar.gz .";
  fixpuPhase = "";
  dontPatchShebangs = true;
})
