{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  writeText,
  runCommand,
}:

let
  oxitest = buildPythonPackage rec {
    pname = "oxitest";
    version = "1.0.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "kalonji-tools";
      repo = "oxitest";
      tag = "v${version}";
      hash = "sha256-X4xRXqXXsc8bGydHGk3w2j/klL/TXa7tEKt42kHTQGk=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-nBEmgsU7WDIsy32UclzwqHz10KAMlQ5htZ3+jgPsUnc=";
    };

    nativeBuildInputs = [
      cargo
      rustPlatform.cargoSetupHook
      rustPlatform.maturinBuildHook
      rustc
    ];

    doCheck = false;

    pythonImportsCheck = [ "oxitest" ];

    passthru.tests = {
      version = runCommand "${pname}-version-test" { } ''
        ${lib.getExe oxitest} --version | grep -q "${version}"
        touch $out
      '';
      smoke = runCommand "${pname}-smoke-test" { } ''
        ${lib.getExe oxitest} ${writeText "test_smoke.py" ''
          def test_smoke():
              assert 1 + 1 == 2, "basic arithmetic should work"
        ''}
        touch $out
      '';
    };

    meta = {
      description = "A fast Python test runner written in Rust";
      homepage = "https://github.com/kalonji-tools/oxitest";
      changelog = "https://github.com/kalonji-tools/oxitest/blob/v${version}/CHANGELOG.md";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ snregales ];
      mainProgram = "oxitest";
    };
  };
in
oxitest
