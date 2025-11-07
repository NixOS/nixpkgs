{
  lib,
  bitvector-for-humans,
  buildPythonPackage,
  busylight-core,
  fastapi,
  fetchFromGitHub,
  hatchling,
  hidapi,
  httpx,
  loguru,
  pyserial,
  pytest-mock,
  pytestCheckHook,
  typer,
  udevCheckHook,
  uvicorn,
  webcolors,
}:

buildPythonPackage rec {
  pname = "busylight-for-humans";
  version = "0.45.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "busylight";
    tag = "v${version}";
    hash = "sha256-G+l+jkHZzz3tX1CcC7Cq1iCFZPbeQ6CI4xCMkTWA5EE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bitvector-for-humans
    busylight-core
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
    httpx
    pytestCheckHook
    pytest-mock
    udevCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

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
