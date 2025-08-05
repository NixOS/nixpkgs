{
  lib,
  buildPythonPackage,
  fetchPypi,
  libargon2,
  cffi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "argon2-cffi-bindings";
  version = "25.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uVfz5upNVdgg5A/3b0UJUoBwE9Nhpl1/KKzArL8pIp0=";
  };

  buildInputs = [ libargon2 ];

  nativeBuildInputs = [
    setuptools-scm
    cffi
  ];

  propagatedBuildInputs = [ cffi ];

  env.ARGON2_CFFI_USE_SYSTEM = 1;

  # tarball doesn't include tests, but the upstream tests are minimal
  doCheck = false;
  pythonImportsCheck = [ "_argon2_cffi_bindings" ];

  meta = with lib; {
    description = "Low-level CFFI bindings for Argon2";
    homepage = "https://github.com/hynek/argon2-cffi-bindings";
    license = licenses.mit;
    maintainers = [ ];
  };
}
