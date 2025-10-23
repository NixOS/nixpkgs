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
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "althonos";
    repo = "gb-io.py";
    rev = "v${version}";
    hash = "sha256-iLRXyiVji9q4C5YtBsTT9bklSueY9RlX7Kz4cu+hmpE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-miwCgZpaFVMaNJLUTYSGEkmg+uT7lbzJZnBa9yZqC8U=";
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

  meta = with lib; {
    homepage = "https://github.com/althonos/gb-io.py";
    description = "Python interface to gb-io, a fast GenBank parser written in Rust";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
