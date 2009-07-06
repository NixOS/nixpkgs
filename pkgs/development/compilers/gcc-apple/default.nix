{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, gmp ? null, mpfr ? null, bison ? null, flex ? null
}:

assert langC;
assert stdenv.isDarwin;
assert langF77 -> gmp != null;

stdenv.mkDerivation ({
  name = "gcc-4.0.1-apple-5484";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.opensource.apple.com/tarballs/gcc/gcc-5484.tar.gz ;
    sha256 = "1cxz9mamb1673b73wywy9v28js04ay73lflpqk78zny5n07c2gv1";
  };
  patches =
    [./pass-cxxcpp.patch]
    ++ (if noSysDirs then [./no-sys-dirs.patch] else []);
  inherit noSysDirs langC langCC langF77 profiledCompiler;
} // (if langF77 then {buildInputs = [gmp mpfr bison flex];} else {}))
