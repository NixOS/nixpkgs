{ stdenv, fetchurl, makeWrapper, jre, gnugrep, coreutils, nixosTests }:
let
  common = { version, sha256, test }:
    stdenv.mkDerivation rec {
      inherit version;

      name = "scala-${version}";

      src = fetchurl {
        inherit sha256;
        url = "https://www.scala-lang.org/files/archive/scala-${version}.tgz";
      };

      propagatedBuildInputs = [ jre ];
      buildInputs = [ makeWrapper ];

      installPhase = ''
        mkdir -p $out
        rm bin/*.bat
        mv * $out

        # put docs in correct subdirectory
        mkdir -p $out/share/doc
        mv $out/doc $out/share/doc/${name}
        mv $out/man $out/share/man

        for p in $(ls $out/bin/) ; do
          wrapProgram $out/bin/$p \
            --prefix PATH ":" ${coreutils}/bin \
            --prefix PATH ":" ${gnugrep}/bin \
            --prefix PATH ":" ${jre}/bin \
            --set JAVA_HOME ${jre}
        done
      '';

      passthru = {
        tests = [ test ];
      };

      meta = {
        description = "A general purpose programming language";
        longDescription = ''
          Scala is a general purpose programming language designed to express
          common programming patterns in a concise, elegant, and type-safe way.
          It smoothly integrates features of object-oriented and functional
          languages, enabling Java and other programmers to be more productive.
          Code sizes are typically reduced by a factor of two to three when
          compared to an equivalent Java application.
        '';
        homepage = "https://www.scala-lang.org/";
        license = stdenv.lib.licenses.bsd3;
        platforms = stdenv.lib.platforms.all;
        branch = stdenv.lib.majorMinor version;
      };
    };
in {
  scala_2_10 = common {
    version = "2.10.7";
    sha256 = "04gi55lzgrhsb78qw8jmnccqim92rw6898knw0a7gfzn2sci30wj";
    test = { inherit (nixosTests) scala_2_10; };
  };

  scala_2_11 = common {
    version = "2.11.12";
    sha256 = "1a4nc4qp9dm4rps47j92hlmxxqskv67qbdmjqc5zd94wd4rps7di";
    test = { inherit (nixosTests) scala_2_11; };
  };

  scala_2_12 = common {
    version = "2.12.12";
    sha256 = "0avyaa7y8w7494339krcpqhc2p8y5pjk4pz7mqmzdzwy7hgws81m";
    test = { inherit (nixosTests) scala_2_12; };
  };

  scala_2_13 = common {
    version = "2.13.3";
    sha256 = "0zv9w9f6g2cfydsvp8mqcfgv2v3487xp4ca1qndg6v7jrhdp7wy9";
    test = { inherit (nixosTests) scala_2_13; };
  };
}
