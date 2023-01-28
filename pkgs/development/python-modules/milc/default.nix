{ lib
, buildPythonPackage
, fetchFromGitHub
, appdirs
, argcomplete
, colorama
, halo
, nose2
, semver
}:

buildPythonPackage rec {
  pname = "milc";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "clueboard";
    repo = "milc";
    rev = version;
    sha256 = "sha256-aX6cTpIN9+9xuEGYHVlM5SjTPLcudJFEuOI4CiN3byE=";
  };

  propagatedBuildInputs = [
    appdirs
    argcomplete
    colorama
    halo
  ];

  nativeCheckInputs = [
    nose2
    semver
  ];

  pythonImportsCheck = [ "milc" ];

  meta = with lib; {
    description = "An Opinionated Batteries-Included Python 3 CLI Framework";
    homepage = "https://milc.clueboard.co";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
