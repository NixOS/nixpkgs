{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  # Dependencies
  tomli,
  typer,
}:
buildPythonPackage rec {
  pname = "complexipy";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rohaquinlop";
    repo = "complexipy";
    tag = version;
    hash = "sha256-M2u8qfc0B5UPzEEGFPpE5chLnAz/jCsvPjj+nAfbXSs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-m+ibMqwWf1CNKz1RhG7+GA601WmncQnRSxB+F8/3NRw=";
  };

  dependencies = [
    tomli
    typer
  ];

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    pytest
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export PYTHONPATH="$out/${python.sitePackages}"
    pytest ${src}/tests/main.py

    # mirror upstream CLI test
    export PATH="$out/bin:$PATH"
    complexipy complexipy --failed

    runHook postInstallCheck
  '';

  pythonImportsCheck = [ "complexipy" ];

  meta = {
    description = "Blazingly fast cognitive complexity analysis for Python, written in Rust";
    homepage = "https://github.com/rohaquinlop/complexipy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ traphi ];
    mainProgram = "complexipy";
  };
}
