{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flaky,
  hatch-vcs,
  hatchling,
  httpx,
  pytest-random-order,
  pytest-recording,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylast";
  version = "7.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylast";
    repo = "pylast";
    tag = version;
    hash = "sha256-NA49V9s4k0l0icoiKVjxTAdhC+MuNgbbeImAjzGB8Xo=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ httpx ];

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
