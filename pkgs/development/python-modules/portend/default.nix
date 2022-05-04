{ lib, buildPythonPackage, fetchPypi
, pytestCheckHook, setuptools-scm, tempora  }:

buildPythonPackage rec {
  pname = "portend";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "239e3116045ea823f6df87d6168107ad75ccc0590e37242af0cc1e98c5d224e4";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ tempora ];

  checkInputs = [ pytestCheckHook ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Monitor TCP ports for bound or unbound states";
    homepage = "https://github.com/jaraco/portend";
    license = licenses.bsd3;
  };
}
