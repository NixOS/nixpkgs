{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  geojson,
  google-api-core,
  imagesize,
  nbconvert,
  nbformat,
  numpy,
  opencv4,
  packaging,
  pillow,
  pydantic,
  pyproj,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  setuptools,
  shapely,
  strenum,
  tqdm,
  typeguard,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "labelbox";
  version = "3.67.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Labelbox";
    repo = "labelbox-python";
    rev = "refs/tags/v.${version}";
    hash = "sha256-JQTjmYxPBS8JC4HQTtbQ7hb80LPLYE4OEj1lFA6cZ1Y=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "--reruns 2 --reruns-delay 10 --durations=20 -n 10" ""

    # disable pytest_plugins which requires `pygeotile`
    substituteInPlace tests/conftest.py \
      --replace-fail "pytest_plugins" "_pytest_plugins"
  '';


  pythonRelaxDeps = [ "python-dateutil" ];

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    pydantic
    python-dateutil
    requests
    strenum
    tqdm
  ];

  optional-dependencies = {
    data = [
      shapely
      geojson
      numpy
      pillow
      opencv4
      typeguard
      imagesize
      pyproj
      # pygeotile
      typing-extensions
      packaging
    ];
  };

  nativeCheckInputs = [
    nbconvert
    nbformat
    pytestCheckHook
  ] ++ optional-dependencies.data;

  disabledTestPaths = [
    # Requires network access
    "tests/integration"
    # Missing requirements
    "tests/data"
  ];

  pythonImportsCheck = [ "labelbox" ];

  meta = with lib; {
    description = "Platform API for LabelBox";
    homepage = "https://github.com/Labelbox/labelbox-python";
    changelog = "https://github.com/Labelbox/labelbox-python/blob/v.${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
