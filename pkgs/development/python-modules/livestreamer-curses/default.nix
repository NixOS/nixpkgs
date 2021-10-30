{ lib
, buildPythonPackage
, fetchFromGitHub
, isPyPy
, livestreamer
}:

buildPythonPackage rec {
  version = "1.5.2";
  pname = "livestreamer-curses";
  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "gapato";
    repo = "livestreamer-curses";
    rev = "v1.5.2";
    sha256 = "sha256-Pi0PIOUhMMAWft9ackB04IgF6DyPrXppNqyVjozIjN4=";
  };

  propagatedBuildInputs = [ livestreamer ];

  meta = with lib; {
    homepage = "https://github.com/gapato/livestreamer-curses";
    description = "Curses frontend for livestreamer";
    license = licenses.mit;
  };

}
