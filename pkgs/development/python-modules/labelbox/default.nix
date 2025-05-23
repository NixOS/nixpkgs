{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  geojson,
  google-api-core,
  hatchling,
  imagesize,
  mypy,
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
  requests,
  shapely,
  strenum,
  tqdm,
  typeguard,
  typing-extensions,
}:

let
  version = "6.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Labelbox";
    repo = "labelbox-python";
    tag = "v.${version}";
    hash = "sha256-EstHsY9yFeUhQAx3pgvKk/o3EMkr3JeHDDg/p6meDIE=";
  };

  lbox-clients = buildPythonPackage {
    inherit src version pyproject;

    pname = "lbox-clients";

    sourceRoot = "${src.name}/libs/lbox-clients";

    build-system = [ hatchling ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace "--durations=20 --cov=lbox.example" "--durations=20"
    '';

    dependencies = [
      google-api-core
      requests
    ];

    nativeCheckInputs = [
      pytestCheckHook
    ];

    doCheck = true;

    __darwinAllowLocalNetworking = true;
  };
in
buildPythonPackage rec {
  inherit src version pyproject;

  pname = "labelbox";

  sourceRoot = "${src.name}/libs/labelbox";

  pythonRelaxDeps = [
    "mypy"
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
    mypy
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
  ] ++ optional-dependencies.data;

  disabledTestPaths = [
    # Requires network access
    "tests/integration"
    # Missing requirements
    "tests/data"
    "tests/unit/test_label_data_type.py"
  ];

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "labelbox" ];

  meta = {
    description = "Platform API for LabelBox";
    homepage = "https://github.com/Labelbox/labelbox-python";
    changelog = "https://github.com/Labelbox/labelbox-python/releases/tag/v.${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rakesh4g ];
  };
}
