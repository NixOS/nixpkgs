{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  wheel,
  versionCheckHook,
  nix-update-script,
  withCli ? false,

  # dependencies
  jsonschema,
  numpy,
  onnxruntime,
  opencv-python-headless,
  pillow,
  pooch,
  pymatting,
  scikit-image,
  scipy,
  tqdm,

  # optional-dependencies
  aiohttp,
  asyncer,
  click,
  fastapi,
  filetype,
  gradio,
  python-multipart,
  uvicorn,
  watchdog,
}:

buildPythonPackage rec {
  pname = "rembg";
  version = "2.0.62";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "danielgatis";
    repo = "rembg";
    tag = "v${version}";
    hash = "sha256-7jppiAdeR5f0Oufj2CWonuyfvqI8hpO7PMp3qB3f8g8=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    jsonschema
    numpy
    opencv-python-headless
    onnxruntime
    pillow
    pooch
    pymatting
    scikit-image
    scipy
    tqdm
  ] ++ lib.optionals withCli optional-dependencies.cli;

  optional-dependencies = {
    cli = [
      aiohttp
      asyncer
      click
      fastapi
      filetype
      gradio
      python-multipart
      uvicorn
      watchdog
    ];
  };

  preConfigure = ''
    export NUMBA_CACHE_DIR="$(mktemp -d)"
  '';

  postInstall = lib.optionalString (!withCli) "rm -r $out/bin";

  nativeCheckInputs = lib.optional withCli versionCheckHook;
  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "rembg" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to remove background from images";
    homepage = "https://github.com/danielgatis/rembg";
    changelog = "https://github.com/danielgatis/rembg/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "rembg";
  };
}
