{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pafy
}:

buildPythonPackage rec {
  name = "mps-youtube-${version}";
  version = "0.2.7.1";
  disabled = (!isPy3k);

  src = fetchFromGitHub {
    owner = "mps-youtube";
    repo = "mps-youtube";
    rev = "v${version}";
    sha256 = "16zn5gwb3568w95lr21b88zkqlay61p1541sa9c3x69zpi8v0pys";
  };

  propagatedBuildInputs = [ pafy ];

  # disabled due to error in loading unittest
  # don't know how to make test from: <mps_youtube. ...>
  doCheck = false;

  # before check create a directory and redirect XDG_CONFIG_HOME to it
  preCheck = ''
    mkdir -p check-phase
    export XDG_CONFIG_HOME=$(pwd)/check-phase
  '';

  meta = with stdenv.lib; {
    description = "Terminal based YouTube player and downloader";
    homepage = https://github.com/np1/mps-youtube;
    license = licenses.gpl3;
    maintainers = with maintainers; [ odi ];
  };

}
