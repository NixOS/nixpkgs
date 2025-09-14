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
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "dbt_extractor";
    inherit version;
    hash = "sha256-1s8I7Hk7i8K9biYO+BgjCuaKT3FDb6SJ8I19saUuL/4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-6Y4zfqhj1/IeEX+Ve49jblxeW565Q2ypNClb/Ej0xoc=";
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
