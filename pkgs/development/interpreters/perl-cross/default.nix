{ lib, stdenv, buildPackages, fetchurl }:

let common = {perlVersion, perlSha256}:
  stdenv.mkDerivation rec {
    name = "perl-cross";
    version = perlVersion;
    crossVersion = "1.1.7";

    srcs = [
      (fetchurl {
        url = "mirror://cpan/src/5.0/perl-${perlVersion}.tar.gz";
        sha256 = perlSha256;
      })

      (fetchurl {
        url = "https://github.com/arsv/perl-cross/releases/download/${crossVersion}/${name}-${crossVersion}.tar.gz";
        sha256 = "0ps1x7wxi3b52igywhx4d6xyr26s87aqdjvkgsnjgxdmcvbyk75p";
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
    perlVersion = "5.22.2";
    perlSha256 = "1yk1xn4wmnrf2ph02j28khqarpyr24qwysjzkjnjv7vh5dygb7ms";
  };

  perl524 = common {
    perlVersion = "5.24.2";
    perlSha256 = "1x4yj814a79lcarwb3ab6bbcb36hvb5n4ph4zg3yb0nabsjfi6v0";
  };

  perl526 = common {
    perlVersion = "5.26.2";
    perlSha256 = "1p81wwvr5jb81m41d07kfywk5gvbk0axdrnvhc2aghcdbr4alqz7";
  };
}
