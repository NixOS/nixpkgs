{ lib
, buildPythonPackage
, fetchPypi
, pyparsing
, six
, pytestCheckHook
, pretend
, flit-core
, setuptools
}:

buildPythonPackage rec {
  pname = "packaging";
  version = "20.8";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eFmBhacAikcNZFJqgFnemqpEkjjygPyetrE7psQQkJM=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [ pyparsing setuptools six ];

  checkInputs = [
    pytestCheckHook
    pretend
  ];

  # Prevent circular dependency
  doCheck = false;

  pythonImportsCheck = [ "packaging" ];

  meta = with lib; {
    description = "Core utilities for Python packages";
    homepage = "https://github.com/pypa/packaging";
    license = [ licenses.bsd2 licenses.asl20 ];
    maintainers = with maintainers; [ bennofs ];
  };
}
