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
  version = "19.1.0";
  name    = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81548a27b919861040cb928a350733f4f9455dd67c7d1ba92eb5960a1d7f8b26";
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
