{ stdenv, fetchurl, noSysDirs
, langCC ? true, langObjC ? true, langF77 ? false
, profiledCompiler ? false
, gmp ? null, mpfr ? null, bison ? null, flex ? null
}:

assert stdenv.isDarwin;
assert langF77 -> gmp != null;

let
  version  = "4.2.1";   # Upstream GCC version, from `gcc/BASE-VER'.
  revision = "5666.3";  # Apple's fork revision number.
in

stdenv.mkDerivation {
  name = "gcc-apple-${version}.${revision}";

  builder = ./builder.sh;

  src =
    stdenv.lib.optional true (fetchurl {
      url = "http://www.opensource.apple.com/tarballs/gcc/gcc-${revision}.tar.gz";
      sha256 = "0nq1szgqx9ryh1qsn5n6yd55gpvf56wr8f7w1jzabb8idlvz8ikc";
    }) ++
    stdenv.lib.optional langCC (fetchurl {
      url = http://www.opensource.apple.com/tarballs/libstdcxx/libstdcxx-39.tar.gz;
      sha256 = "ccf4cf432c142778c766affbbf66b61001b6c4f1107bc2b2c77ce45598786b6d";
    });

  enableParallelBuilding = true;

  libstdcxx = "libstdcxx-39";

  sourceRoot = "gcc-${revision}/";

  patches =
    [ ./pass-cxxcpp.patch ./fix-libstdc++-link.patch ]
    ++ stdenv.lib.optional noSysDirs [ ./no-sys-dirs.patch ];

  inherit noSysDirs langCC langF77 langObjC;
  langC = true;

  buildInputs = stdenv.lib.optionals langF77 [ gmp mpfr bison flex ];
}
