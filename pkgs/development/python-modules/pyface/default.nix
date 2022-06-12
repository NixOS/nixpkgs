{ lib
, fetchPypi
, buildPythonPackage
, importlib-metadata
, importlib-resources
, traits
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyface";
  version = "7.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UtzzZ5yj5hCjynxLmQSpbGkWiASNtdflKvjlAZ5HrbY=";
  };

  propagatedBuildInputs = [
    importlib-metadata
    importlib-resources
    traits
  ];

  doCheck = false; # Needs X server

  pythonImportsCheck = [
    "pyface"
  ];

  meta = with lib; {
    description = "Traits-capable windowing framework";
    homepage = "https://github.com/enthought/pyface";
    maintainers = with maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
