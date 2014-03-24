{ stdenv, fetchurl, perl, icu, jdk, git, zlib, gmp, readline
, useStar ? false }:

with stdenv.lib;

let
  rakudoNom = rec {
    name    = "rakudo-${version}";
    version = "2014.03.01";
    src = fetchurl {
      url    = "https://github.com/rakudo/rakudo/archive/${version}.tar.gz";
      sha256 = "0pxv509431wvn0xiqd69zzx3hz0jwlwrbmzc958jgr1i2h2s2v7b";
    };
  };

  rakudoStar = rec {
    name    = "rakudo-star-${version}";
    version = "2014.01";
    src = fetchurl {
      url    = "http://rakudo.org/downloads/star/${name}.tar.gz";
      sha256 = "1j432wpcpvv7pk71xv1im8lwnql0rnkp25k2h8nmniw8gi9jhzh1";
    };
  };

  rakudoPkg = if useStar then rakudoStar else rakudoNom;
in
stdenv.mkDerivation (rakudoPkg // {
  buildInputs = [ perl icu jdk git zlib gmp readline ];
  checkTarget = "test";
  doCheck     = true;

  configureScript = "perl ./Configure.pl";
  configureFlags =
    [ "--gen-nqp"
      "--gen-parrot"
      ("--backends=jvm,parrot" + (optionalString (!useStar) ",moar --gen-moar"))
    ];

  meta = {
    description = "A Perl 6 implementation";
    homepage    = "http://www.rakudo.org";
    license     = stdenv.lib.licenses.artistic2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
})
