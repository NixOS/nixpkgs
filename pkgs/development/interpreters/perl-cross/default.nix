{ lib, stdenv, buildPackages, fetchurl }:

let common = {perlVersion, perlSha256}:
  stdenv.mkDerivation rec {
    name = "perl-cross";
    version = perlVersion;
    crossVersion = "1.1.8";

    srcs = [
      (fetchurl {
        url = "mirror://cpan/src/5.0/perl-${perlVersion}.tar.gz";
        sha256 = perlSha256;
      })

      (fetchurl {
        url = "https://github.com/arsv/perl-cross/releases/download/${crossVersion}/${name}-${crossVersion}.tar.gz";
        sha256 = "072j491rpz2qx2sngbg4flqh4lx5865zyql7b9lqm6s1kknjdrh8";
      })
    ];
    sourceRoot = "perl-${perlVersion}";

    nativeBuildInputs = [ buildPackages.stdenv.cc ];

    postUnpack = "cp -R perl-cross-${crossVersion}/* perl-${perlVersion}";

    configurePlatforms = [ "build" "host" "target" ];

    enableParallelBuilding = false;

    passthru.libPrefix = "lib/perl5/site_perl";

    meta = {
      homepage = https://arsv.github.io/perl-cross;
      description = "Cross-compilation standard implementation of the Perl 5 programmming language";
      maintainers = [ ];
      platforms = lib.platforms.all;
    };
  };

in rec {

  perl = perl524;

  perl522 = common {
    perlVersion = "5.22.4";
    perlSha256 = "1yk1xn4wmnrf2ph02j28khqarpyr24qwysjzkjnjv7vh5dygb7ms";
  };

  perl524 = common {
    perlVersion = "5.24.3";
    perlSha256 = "1m2px85kq2fyp2d4rx3bw9kg3car67qfqwrs5vlv96dx0x8rl06b";
  };

  perl526 = common {
    perlVersion = "5.26.1";
    perlSha256 = "1p81wwvr5jb81m41d07kfywk5gvbk0axdrnvhc2aghcdbr4alqz7";
  };
}
