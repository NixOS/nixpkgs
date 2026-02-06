{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  jsonschema,
  numpy,
  onnxruntime,
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
  sniffio,
  uvicorn,
  watchdog,

  # tests
  versionCheckHook,

  withCli ? false,
}:

let
  isNotAarch64Linux = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
in
buildPythonPackage (finalAttrs: {
  pname = "rembg";
  version = "2.0.72";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danielgatis";
    repo = "rembg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KYpqRuC7EjgH0UqgIoMaeHF3oQSI87j6J3bcqU+43Wo=";
  };

  env.POETRY_DYNAMIC_VERSIONING_BYPASS = finalAttrs.version;

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  pythonRelaxDeps = [
    "jsonschema"
    "pillow"
    "pymatting"
    "scikit-image"
  ];
  dependencies = [
    jsonschema
    numpy
    onnxruntime
    pillow
    pooch
    pymatting
    scikit-image
    scipy
    tqdm
  ]
  ++ lib.optionals withCli finalAttrs.passthru.optional-dependencies.cli;

  optional-dependencies = {
    cli = [
      aiohttp
      asyncer
      click
      fastapi
      filetype
      gradio
      python-multipart
      sniffio
      uvicorn
      watchdog
    ];
  };

  preConfigure = ''
    export NUMBA_CACHE_DIR="$(mktemp -d)"
  '';

  postInstall = lib.optionalString (!withCli) "rm -r $out/bin";

  # not running python tests, as they require network access
  nativeCheckInputs = lib.optionals withCli [
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [
    # Otherwise, fail with:
    # RuntimeError: cannot cache function '_make_tree': no locator available for file
    # '{{storeDir}}/lib/python3.13/site-packages/pymatting/util/kdtree.py'
    "NUMBA_CACHE_DIR"
  ];

  # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
  # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
  #
  # -> Skip all tests that require importing rembg
  pythonImportsCheck = lib.optionals isNotAarch64Linux [ "rembg" ];
  doCheck = isNotAarch64Linux;

  meta = {
    description = "Tool to remove background from images";
    homepage = "https://github.com/danielgatis/rembg";
    changelog = "https://github.com/danielgatis/rembg/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "rembg";
  };
})
