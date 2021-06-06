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
  version = "20.1.0";

  src = fetchPypi {
    pname = "argon2-cffi";
    inherit version;
    sha256 = "0zgr4mnnm0p4i99023safb0qb8cgvl202nly1rvylk2b7qnrn0nq";
  };

  propagatedBuildInputs = [ cffi six ] ++ lib.optional (!isPy3k) enum34;
  checkInputs = [ hypothesis pytest wheel ];
  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Secure Password Hashes for Python";
    homepage    = "https://argon2-cffi.readthedocs.io/";
    license     = licenses.mit;
  };
}
