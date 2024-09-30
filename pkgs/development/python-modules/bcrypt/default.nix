{
  lib,
  buildPythonPackage,
  cargo,
  rustPlatform,
  rustc,
  setuptools,
  setuptools-rust,
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
  version = "4.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LuFd10n1lS/j8EMND/a3QILhWcUDMqFBPVG1aJzwZiM=";
  };

  cargoRoot = "src/_bcrypt";
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-Uag1pUuis5lpnus2p5UrMLa4HP7VQLhKxR5TEMfpK0s=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-rust
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
