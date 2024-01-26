{ lib
, buildPythonPackage
, cargo
, rustPlatform
, rustc
, setuptools
, setuptools-rust
, fetchPypi
, pythonOlder
, pytestCheckHook
, libiconv
, stdenv
  # for passthru.tests
, asyncssh
, django_4
, fastapi
, paramiko
, twisted
}:

buildPythonPackage rec {
  pname = "bcrypt";
  version = "4.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J9N1kDrIJhz+QEf2cJ0W99GNObHskqr3KvmJVSplDr0=";
  };

  cargoRoot = "src/_bcrypt";
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-lDWX69YENZFMu7pyBmavUZaalGvFqbHSHfkwkzmDQaY=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  # Remove when https://github.com/NixOS/nixpkgs/pull/190093 lands.
  buildInputs = lib.optional stdenv.isDarwin libiconv;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bcrypt"
  ];

  passthru.tests = {
    inherit asyncssh django_4 fastapi paramiko twisted;
  };

  meta = with lib; {
    description = "Modern password hashing for your software and your servers";
    homepage = "https://github.com/pyca/bcrypt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ domenkozar ];
  };
}
