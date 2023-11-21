{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, lxml
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pytrafikverket";
  version = "0.3.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3p2tKFuzgl+VFRRXV66MRgcL1XS8xxDqMOUZw+Ql/5E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    lxml
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pytrafikverket"
  ];

  meta = with lib; {
    description = "Library to get data from the Swedish Transport Administration (Trafikverket) API";
    homepage = "https://github.com/endor-force/pytrafikverket";
    changelog = "https://github.com/endor-force/pytrafikverket/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
