{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, gmp ? null, mpfr ? null, bison ? null, flex ? null
}:

assert langC;
assert stdenv.isDarwin;
assert langF77 -> gmp != null;

stdenv.mkDerivation ({
  name = "gcc-4.2.1-apple-5531";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.opensource.apple.com/tarballs/gcc_42/gcc_42-5531.tar.gz ;
    sha256 = "0bk37axx202x0ll1f8q00p233n3j8zga09ljxia1g89g17i64j4j";
  };
  patches =
    [./pass-cxxcpp.patch]
    ++ (if noSysDirs then [./no-sys-dirs.patch] else []);
  inherit noSysDirs langC langCC langF77 profiledCompiler;
} // (if langF77 then {buildInputs = [gmp mpfr bison flex];} else {}))
