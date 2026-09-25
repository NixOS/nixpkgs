{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  geojson,
  google-api-core,
  hatchling,
  imagesize,
  lbox-clients,
  nbconvert,
  nbformat,
  numpy,
  opencv-python-headless,
  pillow,
  pydantic,
  pyproj,
  pytest-cov-stub,
  pytest-order,
  pytest-rerunfailures,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  requests,
  shapely,
  strenum,
  tqdm,
  typeguard,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "labelbox";
  version = "7.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Labelbox";
    repo = "labelbox-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a3G9Jl1IfbLyI7RZY32zZTbPg8EpSZUrNy12A01Y+Qc=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/labelbox";

  pythonRelaxDeps = [
    "lbox-clients"
    "python-dateutil"
  ];

  build-system = [ hatchling ];

  dependencies = [
    google-api-core
    lbox-clients
    pydantic
    python-dateutil
    requests
    strenum
    tqdm
    geojson
    pyyaml
  ];

  optional-dependencies = {
    data = [
      shapely
      numpy
      pillow
      opencv-python-headless
      typeguard
      imagesize
      pyproj
      # pygeotile
      typing-extensions
    ];
  };

  nativeCheckInputs = [
    nbconvert
    nbformat
    pytest-cov-stub
    pytest-order
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTestPaths = [
    # Requires network access
    "tests/integration"
    # Missing requirements
    "tests/data"
    "tests/unit/test_label_data_type.py"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "labelbox" ];

  meta = {
    description = "Platform API for LabelBox";
    homepage = "https://github.com/Labelbox/labelbox-python";
    changelog = "https://github.com/Labelbox/labelbox-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
})
