{
  lib,
  buildPythonPackage,
  cargo,
  rustPlatform,
  rustc,
  setuptools,
  setuptoolsRustBuildHook,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  libiconv,
  stdenv,
  # for passthru.tests
  asyncssh,
  django_4,
  fastapi,
  paramiko,
  twisted,
}:

buildPythonPackage rec {
  pname = "bcrypt";
  version = "4.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oj/SIEF4ttKtzwnLT2Qm/+9UdiV3p8m1TBWQCMsojBg=";
  };

  cargoRoot = "src/_bcrypt";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-HgHvfMBspPsSYhllnKBg5XZB6zxFIqJj+4//xKG8HwA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptoolsRustBuildHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  # Remove when https://github.com/NixOS/nixpkgs/pull/190093 lands.
  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

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

  meta = with lib; {
    description = "Modern password hashing for your software and your servers";
    homepage = "https://github.com/pyca/bcrypt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
