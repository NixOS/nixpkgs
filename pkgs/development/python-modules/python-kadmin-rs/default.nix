{
  lib,
  pkgs,
  fetchFromGitHub,
  rustPlatform,
  pythonImportsCheckHook,
  buildPythonPackage,
  pkg-config,
  heimdal,
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

  # The include directories of krb5 and heimdal contain overlapping paths.
  # Only add one and set the other required paths via environment variables.
  buildInputs = [
    pkgs.krb5
  ];

  env = {
    KADMIN_MIT_CLIENT_INCLUDES = "${pkgs.krb5.dev}/include";
    KADMIN_MIT_SERVER_INCLUDES = "${pkgs.krb5.dev}/include";
    KADMIN_HEIMDAL_CLIENT_INCLUDES = "${heimdal.dev}/include";
    KADMIN_HEIMDAL_SERVER_INCLUDES = "${heimdal.dev}/include";
    KADMIN_MIT_CLIENT_KRB5_CONFIG = "${pkgs.krb5.dev}/bin/krb5-config";
    KADMIN_MIT_SERVER_KRB5_CONFIG = "${pkgs.krb5.dev}/bin/krb5-config";
    KADMIN_HEIMDAL_CLIENT_KRB5_CONFIG = "${heimdal.dev}/bin/krb5-config";
    KADMIN_HEIMDAL_SERVER_KRB5_CONFIG = "${heimdal.dev}/bin/krb5-config";

    K5TEST_MIT_KDB5_UTIL = "${pkgs.krb5}/bin/kdb5_util";
    K5TEST_MIT_KRB5KDC = "${pkgs.krb5}/bin/krb5kdc";
    K5TEST_MIT_KADMIN = "${pkgs.krb5}/bin/kadmin";
    K5TEST_MIT_KADMIN_LOCAL = "${pkgs.krb5}/bin/kadmin.local";
    K5TEST_MIT_KADMIND = "${pkgs.krb5}/bin/kadmind";
    K5TEST_MIT_KPROP = "${pkgs.krb5}/bin/kprop";
    K5TEST_MIT_KINIT = "${pkgs.krb5}/bin/kinit";
    K5TEST_MIT_KLIST = "${pkgs.krb5}/bin/klist";

    K5TEST_HEIMDAL_KDC = "${heimdal}/libexec/kdc";
    K5TEST_HEIMDAL_KADMIN = "${heimdal}/bin/kadmin";
    K5TEST_HEIMDAL_KADMIND = "${heimdal}/libexec/kadmind";
    K5TEST_HEIMDAL_KINIT = "${heimdal}/bin/kinit";
    K5TEST_HEIMDAL_KLIST = "${heimdal}/bin/klist";
    K5TEST_HEIMDAL_KTUTIL = "${heimdal}/bin/ktutil";
  };

  nativeBuildInputs = [
    pkg-config
    pythonImportsCheckHook
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
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
