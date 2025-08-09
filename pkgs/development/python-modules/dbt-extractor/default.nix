{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  libiconv,
  pythonOlder,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "dbt-extractor";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "dbt_extractor";
    inherit version;
    hash = "sha256-zV2VV2qN6kGQJAqvmTajf9dLS3kTymmjw2j8RHK7fhM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-luPAuRl+yrHinLs6H0ZRVnce2zz1DUrniVOCa1hu1S4=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  # no python tests exist
  doCheck = false;

  pythonImportsCheck = [ "dbt_extractor" ];

  meta = with lib; {
    description = "Tool that processes the most common jinja value templates in dbt model files";
    homepage = "https://github.com/dbt-labs/dbt-extractor";
    changelog = "https://github.com/dbt-labs/dbt-extractor/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      mausch
      tjni
    ];
  };
}
