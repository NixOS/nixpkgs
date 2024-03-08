{ lib, buildPythonPackage, fetchPypi
, setuptools-git, pytest }:

buildPythonPackage rec {
  pname = "pytest-fixture-config";
  version = "1.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13i1qpz22w3x4dmw8vih5jdnbqfqvl7jiqs0dg764s0zf8bp98a1";
  };

  nativeBuildInputs = [ setuptools-git ];

  buildInputs = [ pytest ];

  doCheck = false;

  meta = with lib; {
    description = "Simple configuration objects for Py.test fixtures. Allows you to skip tests when their required config variables aren’t set.";
    homepage = "https://github.com/manahl/pytest-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ ryansydnor ];
  };
}
