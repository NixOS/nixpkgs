{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ndspy";
  version = "4.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "RoadrunnerWMC";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-V7phRZCA0WbUpYLgS/4nJbje/JM61RksDUZQ2pnbQyU=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ndspy"
  ];

  preCheck = ''
    cd tests
  '';

  meta = with lib; {
    description = "Python library for many Nintendo DS file formats";
    homepage = "https://github.com/RoadrunnerWMC/ndspy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
