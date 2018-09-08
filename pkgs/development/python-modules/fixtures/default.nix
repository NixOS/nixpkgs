{ lib
, buildPythonPackage
, fetchPypi
, pbr
, testtools
, mock
, python
}:

buildPythonPackage rec {
  pname = "fixtures";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fcf0d60234f1544da717a9738325812de1f42c2fa085e2d9252d8fff5712b2ef";
  };

  propagatedBuildInputs = [ pbr testtools mock ];

  checkPhase = ''
    ${python.interpreter} -m testtools.run fixtures.test_suite
  '';

  meta = {
    description = "Reusable state for writing clean tests and more";
    homepage = https://pypi.python.org/pypi/fixtures;
    license = lib.licenses.asl20;
  };
}