{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  cargo,
  rustc,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "gb-io";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "althonos";
    repo = "gb-io.py";
    rev = "v${version}";
    hash = "sha256-6owaHSOVahgOG1gvN4Tox8c49qGzQ4lG1n8GKwEnCRk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-ZUvcbVwhV2P8AvsuVoaPWUW5G9VaEvx3mt4kub0xHRk=";
  };

  sourceRoot = src.name;

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "gb_io" ];

  meta = {
    homepage = "https://github.com/althonos/gb-io.py";
    description = "Python interface to gb-io, a fast GenBank parser written in Rust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
