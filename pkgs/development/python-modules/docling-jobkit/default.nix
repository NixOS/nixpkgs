{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  poetry-core,

  # dependencies
  docling,
  pydantic-settings,
  typer,
  boto3,
  pandas,
  fastparquet,
  pyarrow,
  httpx,

  # optional dependencies
  tesserocr,
  rapidocr-onnxruntime,
  onnxruntime,
  ray,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  writableTmpDirAsHomeHook,

  # options
  withTesserocr ? false,
  withRapidocr ? false,
  withRay ? false,
}:

buildPythonPackage rec {
  pname = "docling-jobkit";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-jobkit";
    tag = "v${version}";
    hash = "sha256-Q4RCA/gJxyfOfzuRnuCmndVEeV0JUCTU389KSEv7vVk=";
  };

  build-system = [
    hatchling
    poetry-core
  ];

  dependencies = [
    docling
    pydantic-settings
    typer
    boto3
    pandas
    fastparquet
    pyarrow
    httpx
  ]
  ++ lib.optionals withTesserocr optional-dependencies.tesserocr
  ++ lib.optionals withRapidocr optional-dependencies.rapidocr
  ++ lib.optionals withRay optional-dependencies.ray;

  optional-dependencies = {
    tesserocr = [ tesserocr ];
    rapidocr = [
      rapidocr-onnxruntime
      onnxruntime
    ];
    ray = [ ray ];
  };

  pythonRelaxDeps = [
    "boto3"
    "pyarrow"
  ];

  pythonImportsCheck = [
    "docling"
    "docling_jobkit"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # requires network access
    "test_convert_url"
    "test_convert_file"
    "test_convert_warmup"
  ];

  meta = {
    changelog = "https://github.com/docling-project/docling-jobkit/blob/${src.tag}/CHANGELOG.md";
    description = "Running a distributed job processing documents with Docling";
    homepage = "https://github.com/docling-project/docling-jobkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ codgician ];
  };
}
