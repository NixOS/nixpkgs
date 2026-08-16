{
  lib,
  bitvector-for-humans,
  buildPythonPackage,
  busylight-core,
  fastapi,
  fetchFromGitHub,
  hidapi,
  httpx,
  loguru,
  pyserial,
  pytest-mock,
  pytestCheckHook,
  typer,
  udevCheckHook,
  uv-build,
  uvicorn,
  webcolors,
}:

buildPythonPackage (finalAttrs: {
  pname = "busylight-for-humans";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "busylight";
    tag = "busylight-cli/v${finalAttrs.version}";
    hash = "sha256-h+YPrcf32SgzdQDYCeQlh4enzsXfsHr470W3tiFBO7g=";
    rootDir = "packages/busylight";
  };

  build-system = [ uv-build ];

  dependencies = [
    busylight-core
    hidapi
    loguru
    pyserial
    typer
    webcolors
  ];

  optional-dependencies = {
    web = [ fastapi ];
    webapi = [
      fastapi
      uvicorn
    ];
  };

  nativeCheckInputs = [
    httpx
    pytestCheckHook
    udevCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "busylight" ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    $out/bin/busylight udev-rules -o $out/lib/udev/rules.d/99-busylight.rules
  '';

  meta = {
    description = "Control USB connected presence lights from multiple vendors via the command-line or web API";
    homepage = "https://github.com/JnyJny/busylight";
    changelog = "https://github.com/JnyJny/busylight/blob/${finalAttrs.src.tag}/${finalAttrs.src.rootDir}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ helsinki-Jo ];
    mainProgram = "busylight";
  };
})
