{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, gmp ? null, mpfr ? null, bison ? null, flex ? null
}:

assert langC;
assert stdenv.isDarwin;
assert langF77 -> gmp != null;

stdenv.mkDerivation ({
  name = "gcc-4.2.1-apple-5646";
  builder = ./builder.sh;
  src = 
    stdenv.lib.optional /*langC*/ true (fetchurl {
      url = http://www.opensource.apple.com/tarballs/gcc/gcc-5646.tar.gz;
      sha256 = "13jghyb098104kfym96iwwdvbj6snnws2c92h48lbd4fmyf1iv24";
    }) ++
    stdenv.lib.optional langCC (fetchurl {
      url = http://www.opensource.apple.com/tarballs/libstdcxx/libstdcxx-39.tar.gz ;
      sha256 = "1fy6j41rhxdsm19sib9wygjl5l54g8pm13c6y5x13f40mavw1mma";
    }) ;

  libstdcxx = "libstdcxx-39";
  sourceRoot = "gcc-5646/";
  patches =
    [./pass-cxxcpp.patch ]
    ++ (if noSysDirs then [./no-sys-dirs.patch] else []);
  inherit noSysDirs langC langCC langF77 profiledCompiler;
} // (if langF77 then {buildInputs = [gmp mpfr bison flex];} else {}))
