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
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylast";
    repo = "pylast";
    tag = version;
    hash = "sha256-u+wQxw0F/1oB8Kr4terSPo/8/RyPhiKxU0GruZo73H0=";
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

  meta = with lib; {
    description = "Python interface to last.fm (and compatibles)";
    homepage = "https://github.com/pylast/pylast";
    changelog = "https://github.com/pylast/pylast/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      fab
      rvolosatovs
    ];
  };
}
