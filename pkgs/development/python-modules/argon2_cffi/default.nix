{ lib
, cffi
, six
, hypothesis
, pytest
, wheel
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "argon2_cffi";
  version = "16.3.0";
  name    = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ap3il3j1pjyprrhpfyhc21izpmhzhfb5s69vlzc65zvd1nj99cr";
  };

  propagatedBuildInputs = [ cffi six ];
  checkInputs = [ hypothesis pytest wheel ];
  checkPhase = ''
    pytest tests
  '';

  meta = {
    description = "Secure Password Hashes for Python";
    homepage    = https://argon2-cffi.readthedocs.io/;
  };
}
