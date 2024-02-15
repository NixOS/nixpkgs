{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "easydict";
  version = "1.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BVXMw6c9hhSQGzaLcsKK1Hbszhd9vfQkyD4IwXpJ4HY=";
  };

  doCheck = false; # No tests in archive

  pythonImportsCheck = [
    "easydict"
  ];

  meta = with lib; {
    homepage = "https://github.com/makinacorpus/easydict";
    license = licenses.lgpl3;
    description = "Access dict values as attributes (works recursively)";
  };
}
