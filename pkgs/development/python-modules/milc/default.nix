{ lib
, buildPythonPackage
, fetchFromGitHub
, appdirs
, argcomplete
, colorama
, halo
, spinners
, types-colorama
, nose2
, semver
}:

buildPythonPackage rec {
  pname = "milc";
  version = "1.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "clueboard";
    repo = "milc";
    rev = version;
    hash = "sha256-DUA79R/pf/arG4diJKaJTSLNdB4E0XnS4NULlqP4h/M=";
  };

  propagatedBuildInputs = [
    appdirs
    argcomplete
    colorama
    halo
    spinners
    types-colorama
  ];

  nativeCheckInputs = [
    nose2
    semver
  ];

  pythonImportsCheck = [ "milc" ];

  meta = with lib; {
    description = "An Opinionated Batteries-Included Python 3 CLI Framework";
    mainProgram = "milc-color";
    homepage = "https://milc.clueboard.co";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
