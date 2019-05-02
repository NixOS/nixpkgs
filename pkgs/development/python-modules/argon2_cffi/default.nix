{ cffi
, six
, enum34
, hypothesis
, pytest
, wheel
, buildPythonPackage
, fetchPypi
, isPy3k
, lib
}:

buildPythonPackage rec {
  pname = "argon2_cffi";
  version = "19.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81548a27b919861040cb928a350733f4f9455dd67c7d1ba92eb5960a1d7f8b26";
  };

  propagatedBuildInputs = [ cffi six ] ++ lib.optional (!isPy3k) enum34;
  checkInputs = [ hypothesis pytest wheel ];
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Secure Password Hashes for Python";
    homepage    = https://argon2-cffi.readthedocs.io/;
    license     = licenses.mit;
  };
}
