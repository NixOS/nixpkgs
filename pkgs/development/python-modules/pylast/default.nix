{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flaky,
  hatch-vcs,
  hatchling,
  httpx,
  importlib-metadata,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pylast";
  version = "5.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pylast";
    repo = "pylast";
    tag = version;
    hash = "sha256-QSCqgvhlH87adSq/SYhM/Fxgl7+UOuW9pfUr/q7K36A=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ httpx ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  nativeCheckInputs = [
    pytestCheckHook
    flaky
  ];

  pythonImportsCheck = [ "pylast" ];

  meta = with lib; {
    description = "Python interface to last.fm (and compatibles)";
    homepage = "https://github.com/pylast/pylast";
    changelog = "https://github.com/pylast/pylast/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      fab
      rvolosatovs
    ];
  };
}
