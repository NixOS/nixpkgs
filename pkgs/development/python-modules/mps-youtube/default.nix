{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, pafy
}:

buildPythonPackage rec {
  pname = "mps-youtube";
  version = "0.2.8";
  disabled = (!isPy3k);

  src = fetchFromGitHub {
    owner = "mps-youtube";
    repo = "mps-youtube";
    rev = "v${version}";
    sha256 = "1w1jhw9rg3dx7vp97cwrk5fymipkcy2wrbl1jaa38ivcjhqg596y";
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

  meta = with lib; {
    description = "Terminal based YouTube player and downloader";
    homepage = "https://github.com/mps-youtube/mps-youtube";
    license = licenses.gpl3;
    maintainers = with maintainers; [ odi ];
  };
}
