{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  versionCheckHook,
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
  version = "2.0.65";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danielgatis";
    repo = "rembg";
    tag = "v${version}";
    hash = "sha256-o6M3DSW1GL3xvEx4lsE325J3XcmRrhhPszS5MkaynsE=";
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

  # not running python tests, as they require network access
  nativeCheckInputs = lib.optionals withCli [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "rembg" ];

  meta = {
    description = "Tool to remove background from images";
    homepage = "https://github.com/danielgatis/rembg";
    changelog = "https://github.com/danielgatis/rembg/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "rembg";
    platforms = [ "x86_64-linux" ];
  };
}
