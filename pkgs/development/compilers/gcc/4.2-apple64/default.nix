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

stdenv.mkDerivation rec {
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

  # The floor_log2_patch is from a Gentoo fix for the same issue:
  #   https://bugs.gentoo.org/attachment.cgi?id=363174&action=diff
  patches =
    [ ./pass-cxxcpp.patch ./floor_log2_patch.diff ]
    ++ stdenv.lib.optional noSysDirs ./no-sys-dirs.patch
    ++ stdenv.lib.optional langCC ./fix-libstdc++-link.patch;

  inherit noSysDirs langCC langF77 langObjC;
  langC = true;

  buildInputs = stdenv.lib.optionals langF77 [ gmp mpfr bison flex ];

  #meta.broken = true;
}
