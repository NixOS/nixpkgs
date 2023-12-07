{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pycnite";
  version = "2023.10.11";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rYYWmCvuzDnyCQmZqo/gsESx9nM+w5SEy14JALPIiqE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  meta = {
    homepage = "https://github.com/google/pycnite";
    description = "A collection of utilities for working with compiled Python bytecode";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ jfvillablanca ];
  };
}
