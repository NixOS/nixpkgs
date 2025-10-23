{
  lib,
  pkgs,
  fetchFromGitHub,
  rustPlatform,
  pythonImportsCheckHook,
  buildPythonPackage,

  cargo,
  rustc,
  pkg-config,
  sccache,
  setuptools,
  setuptools-rust,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "python-kadmin-rs";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "authentik-community";
    repo = "kadmin-rs";
    rev = "kadmin/version/${version}";
    hash = "sha256-ofoxgaTflem/QG/aQc6M5oxrUl/YoLHzDWlNyeVr0H8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-mSwuR8TCljPYgVhguZiu2fXprCl+IEyZxE7ML+FBI98=";
  };

  buildInputs = [
    pkgs.krb5
  ];

  nativeBuildInputs = [
    sccache
    pkg-config
    pythonImportsCheckHook
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  build-system = [
    setuptools
    setuptools-rust
    setuptools-scm
  ];

  pythonImportsCheck = [
    "kadmin"
    "kadmin_local"
  ];

  meta = {
    description = "Rust and Python interfaces to the Kerberos administration interface (kadm5)";
    homepage = "https://github.com/authentik-community/kadmin-rs";
    changelog = "https://github.com/authentik-community/kadmin-rs/releases/tag/kadmin%2Fversion%2F${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jvanbruegge
      risson
    ];
  };
}
