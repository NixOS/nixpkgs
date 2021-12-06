{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, pkg-config
, rustPlatform
, libiconv
, stdenv
, toml
}:

buildPythonPackage rec {
  pname = "dbt_extractor";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-lUxMKxO9pkY3I8IM071GWtPPMGLShOpXE7YF/tz440Q=";
  };

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WGcuNvq5iMhJppNAWSDuGEIfJyRcSOX57PSWNp7TGoU=";
  };

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  checkInputs = [ toml ];

  meta = with lib; {
    description = "Jinja processor utilities for dbt";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
