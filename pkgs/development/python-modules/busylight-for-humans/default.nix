{
  lib,
  bitvector-for-humans,
  buildPythonPackage,
  fetchFromGitHub,
  hidapi,
  loguru,
  poetry-core,
  pyserial,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  typer,
  webcolors,
  udevCheckHook,
}:

buildPythonPackage rec {
  pname = "busylight-for-humans";
  version = "0.33.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "busylight";
    tag = version;
    hash = "sha256-0jmaVMN4wwqoO5wGMaV4kJefNUPOuJpWbsqHcZZ0Nh4=";
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
    changelog = "https://github.com/JnyJny/busylight/releases/tag/${version}";
    license = licenses.asl20;
    teams = [ teams.helsinki-systems ];
    mainProgram = "busylight";
  };
}
