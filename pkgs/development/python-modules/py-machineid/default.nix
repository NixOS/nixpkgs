{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "py-machineid";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I1xIXszSzYeqC6rTCF6in24ul5M6+xWsf6oLY4+ksnQ=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "machineid" ];

  # Tests are not present in Pypi archive
  doCheck = false;

  meta = with lib; {
    description = "Get the unique machine ID of any host (without admin privileges";
    homepage = "https://pypi.org/project/py-machineid/";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
