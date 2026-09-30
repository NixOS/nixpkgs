{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flaky,
  hatch-vcs,
  hatchling,
  httpx2,
  pytest-random-order,
  pytest-recording,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylast";
  version = "7.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylast";
    repo = "pylast";
    tag = version;
    hash = "sha256-RpJDCEySM09C9/PGYuT+6+YH7kNFWCSnwbGmUSMqE1I=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ httpx2 ];

  nativeCheckInputs = [
    flaky
    pytest-random-order
    pytest-recording
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylast" ];

  meta = {
    description = "Python interface to last.fm (and compatibles)";
    homepage = "https://github.com/pylast/pylast";
    changelog = "https://github.com/pylast/pylast/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      rvolosatovs
    ];
  };
}
