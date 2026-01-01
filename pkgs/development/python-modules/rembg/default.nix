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
<<<<<<< HEAD
  version = "2.0.69";
=======
  version = "2.0.67";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danielgatis";
    repo = "rembg";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-9Ncs1DHPG3ouU5yFyeH0M2ZCQ9yHqJhVjkDO8fNSqIg=";
=======
    hash = "sha256-QHx1qa1tErneLC1H6df6mTbKTWPh3BzJUqeE65D2c4E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
  ]
  ++ lib.optionals withCli optional-dependencies.cli;

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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "rembg" ];

  meta = {
    description = "Tool to remove background from images";
    homepage = "https://github.com/danielgatis/rembg";
    changelog = "https://github.com/danielgatis/rembg/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "rembg";
<<<<<<< HEAD
=======
    platforms = [ "x86_64-linux" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
