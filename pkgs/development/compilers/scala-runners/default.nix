{
  stdenv,
  lib,
  fetchFromGitHub,
  coursier,
}:

stdenv.mkDerivation {
  pname = "scala-runners";
  version = "unstable-2021-07-28";

  src = fetchFromGitHub {
    repo = "scala-runners";
    owner = "dwijnand";
    rev = "9bf096ca81f4974d7327e291eac291e22b344a8f";
    sha256 = "032fds5nr102h1lc81n9jc60jmxzivi4md4hcjrlqn076hfhj4ax";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin $out/lib
    sed -i -e "s| cs | ${coursier}/bin/cs |" scala-runner
    cp scala-runner $out/lib
    ln -s $out/lib/scala-runner $out/bin/scala
    ln -s $out/lib/scala-runner $out/bin/scalac
    ln -s $out/lib/scala-runner $out/bin/scalap
    ln -s $out/lib/scala-runner $out/bin/scaladoc
  '';

  meta = with lib; {
    homepage = "https://github.com/dwijnand/scala-runners";
    description = "Alternative implementation of the Scala distribution's runners";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ hrhino ];
  };
}
