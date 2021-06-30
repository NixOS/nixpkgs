{ stdenv, lib, fetchFromGitHub, jre, coursier }:

stdenv.mkDerivation rec {
  pname = "scala-runners";
  version = "unstable-2020-02-02";

  src = fetchFromGitHub {
    repo = pname;
    owner = "dwijnand";
    rev = "95e03c9f9de0fe0ab61eeb6dea2a364f9d081d31";
    sha256 = "0mvlc6fxsh5d6gsyak9n3g98g4r061n8pir37jpiqb7z00m9lfrx";
  };

  installPhase = ''
    mkdir -p $out/bin $out/lib
    sed -ie "s| cs | ${coursier}/bin/coursier |" scala-runner
    cp scala-runner $out/lib
    ln -s $out/lib/scala-runner $out/bin/scala
    ln -s $out/lib/scala-runner $out/bin/scalac
    ln -s $out/lib/scala-runner $out/bin/scalap
    ln -s $out/lib/scala-runner $out/bin/scaladoc
  '';

  meta = with lib; {
    homepage = "https://github.com/dwijnand/scala-runners";
    description = "An alternative implementation of the Scala distribution's runners";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ hrhino ];
  };
}
