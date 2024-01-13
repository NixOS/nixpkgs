{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, regex
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysuez";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ooii";
    repo = "pySuez";
    rev = "refs/tags/v${version}";
    hash = "sha256-Xgd0E/oFO2yyytBjuwr1vDJfKWC0Iw8P6GStCuCni/g=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'datetime'" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    regex
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pysuez"
  ];

  meta = with lib; {
    description = "Module to get water consumption data from Suez";
    homepage = "https://github.com/ooii/pySuez";
    changelog = "https://github.com/ooii/pySuez/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
