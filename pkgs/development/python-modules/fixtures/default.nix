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
  version = "1.4.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0djxvdwm8s60dbfn7bhf40x6g818p3b3mlwijm1c3bqg7msn271y";
  };

  propagatedBuildInputs = [ pbr testtools mock ];

  checkPhase = ''
    ${python.interpreter} -m testtools.run fixtures.test_suite
  '';

  meta = {
    description = "Reusable state for writing clean tests and more";
    homepage = "https://pypi.python.org/pypi/fixtures";
    license = lib.licenses.asl20;
  };
}