{ lib, stdenv, fetchurl, makeWrapper, jre, ncurses }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "3.3.0";
=======
  version = "3.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "scala-bare";

  src = fetchurl {
    url = "https://github.com/lampepfl/dotty/releases/download/${version}/scala3-${version}.tar.gz";
<<<<<<< HEAD
    hash = "sha256-Bk7lCKjjucaYQxAsg2qomJQUgCK/N688JqlGTfoQFHU=";
=======
    hash = "sha256-t8Xt70LozePoDXE3IHejWOTWCEYcOZytRDKz/QxgmZg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ jre ncurses.dev ] ;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    mv * $out
  '';

  # Use preFixup instead of fixupPhase
  # because we want the default fixupPhase as well
  preFixup = ''
        bin_files=$(find $out/bin -type f ! -name common)
        for f in $bin_files ; do
          wrapProgram $f --set JAVA_HOME ${jre} --prefix PATH : '${ncurses.dev}/bin'
        done
  '';

  meta = with lib; {
    description = "Research platform for new language concepts and compiler technologies for Scala";
    longDescription = ''
       Dotty is a platform to try out new language concepts and compiler technologies for Scala.
       The focus is mainly on simplification. We remove extraneous syntax (e.g. no XML literals),
       and try to boil down Scala’s types into a smaller set of more fundamental constructs.
       The theory behind these constructs is researched in DOT, a calculus for dependent object types.
    '';
    homepage = "http://dotty.epfl.ch/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [maintainers.karolchmist maintainers.virusdave];
  };
}
