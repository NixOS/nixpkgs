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

buildPythonPackage (finalAttrs: {
  pname = "chardet";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chardet";
    repo = "chardet";
    tag = finalAttrs.version;
    hash = "sha256-cdhxvfyGdUPFKvllg0QhWIHDUGf15HeRmkmi432r5M8=";
  };

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
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ cktiel ];
  };
})
