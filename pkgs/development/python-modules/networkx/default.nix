{ lib
, buildPythonPackage
, fetchPypi
, nose
, pytestCheckHook
, decorator
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "networkx";
  # upgrade may break sage, please test the sage build or ping @timokau on upgrade
  version = "3.1";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3jRjNUCPhN4Orab/n6+v/5vNoR8KDfqpMRM967FGq2E=";
  };

  propagatedBuildInputs = [ decorator setuptools ];
  nativeCheckInputs = [ nose pytestCheckHook ];

  meta = {
    homepage = "https://networkx.github.io/";
    description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
    license = lib.licenses.bsd3;
  };
}
