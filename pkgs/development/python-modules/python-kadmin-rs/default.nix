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
}:

buildPythonPackage rec {
  pname = "python-kadmin-rs";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "authentik-community";
    repo = "kadmin-rs";
    rev = "kadmin/version/${version}";
    hash = "sha256-7aRbpQblRFoCmuZJgm2mrGoUNL0BBcIpzlKblCnHVPc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-dzTcB5GfeUbgikznq4YFEzZ75z0zvz4I1/+5UCQ0e2o=";
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
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  pythonImportsCheck = [
    "kadmin"
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
