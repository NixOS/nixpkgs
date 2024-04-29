{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools
, pytest-cov
}:

buildPythonPackage rec {
  pname = "pynmeagps";
  version = "1.0.35";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "semuconsulting";
    repo = "pynmeagps";
    rev = "v${version}";
    hash = "sha256-ULGBfTHCFGUSF3cmJ4GEUrgGDo4uJwstBj8nZ7tj0AA=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [
    "pynmeagps"
  ];

  meta = {
    homepage = "https://github.com/semuconsulting/pynmeagps";
    description = "NMEA protocol parser and generator";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dylan-gonzalez ];
  };
}
