{
  lib,
  buildPythonPackage,
  cargo,
  rustPlatform,
  rustc,
  setuptools,
  setuptoolsRustBuildHook,
  fetchFromGitHub,
  pytestCheckHook,
  # for passthru.tests
  asyncssh,
  django_4,
  fastapi,
  paramiko,
  twisted,
}:

buildPythonPackage rec {
  pname = "bcrypt";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyca";
    repo = "bcrypt";
    tag = version;
    hash = "sha256-7Dp07xoq6h+fiP7d7/TRRoYszWsyQF1c4vuFUpZ7u6U=";
  };

  cargoRoot = "src/_bcrypt";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-hYMJlwxnXA0ZOJiyZ8rDp9govVcc1SGkDfqUVngnUPQ=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    setuptoolsRustBuildHook # setuptools-rust is insufficient for cross
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bcrypt" ];

  passthru.tests = {
    inherit
      asyncssh
      django_4
      fastapi
      paramiko
      twisted
      ;
  };

  meta = {
    changelog = "https://github.com/pyca/bcrypt/blob/${src.tag}/CHANGELOG.rst";
    description = "Modern password hashing for your software and your servers";
    homepage = "https://github.com/pyca/bcrypt/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
