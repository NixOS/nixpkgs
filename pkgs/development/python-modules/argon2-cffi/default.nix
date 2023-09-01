{ hypothesis
, pytest
, buildPythonPackage
, fetchPypi
, flit-core
, lib
, stdenv
, argon2-cffi-bindings
}:

buildPythonPackage rec {
  pname = "argon2-cffi";
  version = "21.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d384164d944190a7dd7ef22c6aa3ff197da12962bd04b17f64d4e93d934dba5b";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [ argon2-cffi-bindings ];

  nativeCheckInputs = [ hypothesis pytest ];
  checkPhase = ''
    pytest tests
  '';

  pythonImportsCheck = [ "argon2" ];

  meta = with lib; {
    description = "Secure Password Hashes for Python";
    homepage    = "https://argon2-cffi.readthedocs.io/";
    license     = licenses.mit;
  };
}
