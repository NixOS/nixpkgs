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
  version = "4.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z2U4bjq4f1abJ2mIdCA5uqsIeyzbAegJ1050UDwvqv4=";
  };

  cargoRoot = "src/_bcrypt";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-tCeXgypF5Tqnzv7KfoliUZeO6B83YK5cYORhwlvBVnY=";
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
    maintainers = with maintainers; [ domenkozar ];
  };
}
