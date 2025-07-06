{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  setuptools-scm,
  # python dependencies
  docling,
  fastapi,
  httpx,
  pydantic-settings,
  python-multipart,
  uvicorn,
  websockets,
  tesserocr,
  rapidocr-onnxruntime,
  onnxruntime,
  torch,
  torchvision,
  gradio,
  nodejs,
  which,
  withUI ? false,
  withTesserocr ? false,
  withRapidocr ? false,
  withCPU ? false,
}:

buildPythonPackage rec {
  pname = "docling-serve";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-serve";
    tag = "v${version}";
    hash = "sha256-dPCD7Ovc6Xiga+gYOwg0mJIIhHywVOyxKIAFF5XUsYw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"kfp[kubernetes]>=2.10.0",' ""
  '';

  build-system = [
    hatchling
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "websockets"
  ];

  pythonRemoveDeps = [
    "mlx-vlm" # not yet avainable on nixpkgs
  ];

  dependencies =
    [
      docling
      fastapi
      httpx
      pydantic-settings
      python-multipart
      uvicorn
      websockets
    ]
    ++ lib.optionals withUI optional-dependencies.ui
    ++ lib.optionals withTesserocr optional-dependencies.tesserocr
    ++ lib.optionals withRapidocr optional-dependencies.rapidocr
    ++ lib.optionals withCPU optional-dependencies.cpu;

  optional-dependencies = {
    ui = [
      gradio
      nodejs
      which
    ];
    tesserocr = [
      tesserocr
    ];
    rapidocr = [
      rapidocr-onnxruntime
      onnxruntime
    ];
    cpu = [
      torch
      torchvision
    ];
  };

  pythonImportsCheck = [
    "docling_serve"
  ];

  # Require network
  doCheck = false;

  meta = {
    changelog = "https://github.com/docling-project/docling-serve/blob/${src.tag}/CHANGELOG.md";
    description = "Running Docling as an API service";
    homepage = "https://github.com/docling-project/docling-serve";
    license = lib.licenses.mit;
    mainProgram = "docling-serve";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
