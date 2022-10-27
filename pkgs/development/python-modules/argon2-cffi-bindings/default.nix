{ lib
, buildPythonPackage
, fetchPypi
, cffi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "argon2-cffi-bindings";
  version = "21.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb89ceffa6c791807d1305ceb77dbfacc5aa499891d2c55661c6459651fc39e3";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cffi
  ];

  # tarball doesn't include tests, but the upstream tests are minimal
  doCheck = false;
  pythonImportsCheck = [ "_argon2_cffi_bindings" ];

  meta = with lib; {
    description = "Low-level CFFI bindings for Argon2";
    homepage = "https://github.com/hynek/argon2-cffi-bindings";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
