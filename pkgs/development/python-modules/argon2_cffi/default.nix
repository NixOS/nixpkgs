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
  version = "18.1.0";
  name    = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e4b75611b73f53012117ad21cdde7a17b32d1e99ff6799f22d827eb83a2a59b";
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
