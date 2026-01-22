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
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylast";
    repo = "pylast";
    tag = version;
    hash = "sha256-MV7NLh++2GxRvnF30Q3zBOgM6dT8tI/KpQ1YB4rMd1s=";
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
