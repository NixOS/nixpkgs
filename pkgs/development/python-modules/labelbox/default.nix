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
  pythonOlder,
  requests,
  shapely,
  strenum,
  tqdm,
  typeguard,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "labelbox";
  version = "6.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Labelbox";
    repo = "labelbox-python";
    tag = "v.${version}";
    hash = "sha256-aMJJZ9ONnjFK/J4pyLTFQox/cC8ij85IYNlJTFrfV2I=";
  };

  sourceRoot = "${src.name}/libs/labelbox";

  pythonRelaxDeps = [
    "mypy"
    "python-dateutil"
  ];

  build-system = [ hatchling ];

  dependencies = [
    google-api-core
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

  pythonImportsCheck = [ "labelbox" ];

  meta = with lib; {
    description = "Platform API for LabelBox";
    homepage = "https://github.com/Labelbox/labelbox-python";
    changelog = "https://github.com/Labelbox/labelbox-python/releases/tag/v.${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
