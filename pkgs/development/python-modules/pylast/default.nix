{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flaky,
  hatch-vcs,
  hatchling,
  httpx,
  pytest-random-order,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylast";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylast";
    repo = "pylast";
    tag = version;
    hash = "sha256-mwPiHTLFvaCFPZGqi0+T223Ickbm5JP2MJj4gqaj/qo=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytest-random-order
    pytestCheckHook
    flaky
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
