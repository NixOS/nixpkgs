{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  hypothesis,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
}:
let
  test-data = fetchFromGitHub {
    owner = "chardet";
    repo = "test-data";
    tag = "7.7.0";
    hash = "sha256-JZjRfUb+8a1crXbCxmcT2ZzWvNt+Ln6fM0c18kUrDsY=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "chardet";
  version = "7.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chardet";
    repo = "chardet";
    tag = finalAttrs.version;
    hash = "sha256-AwyQ5+vNMINdkJBHHq8dBa4br3TA4hpYMK9E82zrC6U=";
  };

  patchPhase = ''
    ln -s ${test-data} tests/data
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # flaky; https://github.com/chardet/chardet/issues/256
    "test_detect_all_and_detect_one_should_agree"
  ];

  pythonImportsCheck = [ "chardet" ];

  meta = {
    changelog = "https://github.com/chardet/chardet/releases/tag/${finalAttrs.src.tag}";
    description = "Universal encoding detector";
    mainProgram = "chardetect";
    homepage = "https://github.com/chardet/chardet";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ cktiel ];
  };
})
