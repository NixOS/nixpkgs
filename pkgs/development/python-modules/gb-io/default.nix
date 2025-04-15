{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  cargo,
  rustc,
  setuptools-rust,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "gb-io";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "althonos";
    repo = "gb-io.py";
    rev = "v${version}";
    hash = "sha256-xpyfb5pTV8w7S7g2Tagl5N3jLO+IisP2KXuYN/RDDpY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src sourceRoot;
    name = "${pname}-${version}";
    hash = "sha256-97aEuXdq9oEqYJs6sgQU5a0vAMJmWJzu2WGjOqzxZ4c=";
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
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/althonos/gb-io.py";
    description = "Python interface to gb-io, a fast GenBank parser written in Rust";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
