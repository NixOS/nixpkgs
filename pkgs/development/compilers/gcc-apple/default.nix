{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langF77 ? false
, profiledCompiler ? false
, gmp ? null, mpfr ? null, bison ? null, flex ? null
}:

assert langC;
assert stdenv.isDarwin;
assert langF77 -> gmp != null;

stdenv.mkDerivation ({
  name = "gcc-4.2.1-apple-5574";
  builder = ./builder.sh;
  src = 
    stdenv.lib.optional /*langC*/ true (fetchurl {
      url = http://www.opensource.apple.com/tarballs/gcc_42/gcc_42-5574.tar.gz ;
      sha256 = "0b76ef3cded7822e3c0ec430f9811b6bb84895055b683acd2df7f7253d745a50";
    }) ++
    stdenv.lib.optional langCC (fetchurl {
      url = http://www.opensource.apple.com/tarballs/libstdcxx/libstdcxx-16.tar.gz ;
      sha256 = "a7d8041e50e110f5a503e188a05cb217f0c99c51f248a0a1387cc07a0b6f167f";
    }) ;

  enableParallelBuilding = true;

  sourceRoot = "gcc_42-5574/";
  patches =
    [./pass-cxxcpp.patch ./debug_list.patch]
    ++ (if noSysDirs then [./no-sys-dirs.patch] else []);
  inherit noSysDirs langC langCC langF77 profiledCompiler;
} // (if langF77 then {buildInputs = [gmp mpfr bison flex];} else {}))
