{ cffi
, six
, hypothesis
, pytest
, wheel
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "argon2_cffi";
  version = "18.3.0";
  name    = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "003f588de43a817af6ecc1c06103fa0801de63849db3cb0f37576bb2da29043d";
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
