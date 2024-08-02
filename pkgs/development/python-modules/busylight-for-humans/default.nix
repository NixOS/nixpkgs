{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  poetry-core,
  pytestCheckHook,
  pytest-mock,
  bitvector-for-humans,
  hidapi,
  loguru,
  pyserial,
  typer,
  webcolors,
}:
buildPythonPackage rec {
  pname = "busylight-for-humans";
  version = "0.32.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "busylight";
    rev = version;
    hash = "sha256-rdgkTk9x3bO5H01Bo2yOGIIxkoLv1k7kkJidJu/1HDQ=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/JnyJny/busylight/pull/369
      name = "fix-poetry-core.patch";
      url = "https://github.com/helsinki-systems/busylight/commit/74ca283e2250564f422d904ece1b9ab0dd9a8f6c.patch";
      hash = "sha256-eif9ycSYL8ZpXsvNCOHDJlpj12oauyzlMKUScZMzllc=";
    })
  ];

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
  ];

  disabledTestPaths = [ "tests/test_pydantic_models.py" ];

  pythonImportsCheck = [ "busylight" ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    $out/bin/busylight udev-rules -o $out/lib/udev/rules.d/99-busylight.rules
  '';

  meta = with lib; {
    homepage = "https://github.com/JnyJny/busylight";
    description = "Control USB connected presence lights from multiple vendors via the command-line or web API.";
    mainProgram = "busylight";
    license = licenses.asl20;
    maintainers = teams.helsinki-systems.members;
  };
}
