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
  version = "0.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "althonos";
    repo = "gb-io.py";
    rev = "v${version}";
    hash = "sha256-TNjj9hf/3hkf90Pnp60q68sOPhqzkhssPwDku+/oaR0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-h6xQBL3khvpLl4jCtq9Mc5UwQVP78mxKjS+9oeDmSbM=";
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
