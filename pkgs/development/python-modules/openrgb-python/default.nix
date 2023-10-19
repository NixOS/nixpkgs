{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "openrgb-python";
  version = "0.2.15";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rTfpqMM+IUd8rMmw/r15sICLoPHL6KLaRrmUjWTfUkA=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "openrgb"
  ];

  meta = with lib; {
    description = "Module for the OpenRGB SDK";
    homepage = "https://openrgb-python.readthedocs.io/";
    changelog = "https://github.com/jath03/openrgb-python/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
