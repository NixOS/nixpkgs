{
  lib,
  bitvector-for-humans,
  buildPythonPackage,
  fetchFromGitHub,
  fastapi,
  hidapi,
  loguru,
  poetry-core,
  pyserial,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  typer,
  uvicorn,
  webcolors,
  udevCheckHook,
}:

buildPythonPackage rec {
  pname = "busylight-for-humans";
  version = "0.37.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "busylight";
    tag = "v${version}";
    hash = "sha256-uKuQy4ce6WTTpprAbQ6QE7WlotMlVacaDZ+dsvY1N58=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bitvector-for-humans
    hidapi
    loguru
    pyserial
    typer
    webcolors
  ];

  optional-dependencies = {
    webapi = [
      fastapi
      uvicorn
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    udevCheckHook
  ];

  disabledTestPaths = [ "tests/test_pydantic_models.py" ];

  pythonImportsCheck = [ "busylight" ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    $out/bin/busylight udev-rules -o $out/lib/udev/rules.d/99-busylight.rules
  '';

  meta = with lib; {
    description = "Control USB connected presence lights from multiple vendors via the command-line or web API";
    homepage = "https://github.com/JnyJny/busylight";
    changelog = "https://github.com/JnyJny/busylight/releases/tag/${src.tag}";
    license = licenses.asl20;
    teams = [ teams.helsinki-systems ];
    mainProgram = "busylight";
  };
}
