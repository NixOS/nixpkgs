{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, tox
, pip
}:

buildPythonPackage rec {
  pname = "pipdeptree";
  version = "2.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "naiquevin";
    repo = "pipdeptree";
    rev = "${version}";
    sha256 = "sha256-CL0li/79qptOtOGLwder5s0+6zv7+PUnl+bD6p+XBtA=";
  };

  propagatedBuildInputs = [
    pip
  ];

  checkInputs = [
    tox
  ];

  pythonImportsCheck = [
    "pipdeptree"
  ];

  meta = with lib; {
    description = "Command line utility to show dependency tree of packages";
    homepage = "https://github.com/naiquevin/pipdeptree";
    license = licenses.mit;
    maintainers = with maintainers; [ charlesbaynham ];
  };
}
