{ lib
, buildPythonPackage
, fetchFromGitHub
, geojson
, google-api-core
, imagesize
, nbconvert
, nbformat
, numpy
, opencv4
, packaging
, pillow
, pydantic
, pyproj
, pytestCheckHook
, python-dateutil
, pythonOlder
, requests
, setuptools
, shapely
, tqdm
, typeguard
, typing-extensions
}:

buildPythonPackage rec {
  pname = "labelbox";
  version = "3.58.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Labelbox";
    repo = "labelbox-python";
    rev = "refs/tags/v.${version}";
    hash = "sha256-H6fn+TpfYbu/warhr9XcQjfxSThIjBp9XwelA5ZvTBE=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--reruns 5 --reruns-delay 10" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-api-core
    pydantic
    python-dateutil
    requests
    tqdm
  ];

  passthru.optional-dependencies = {
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
  ] ++ passthru.optional-dependencies.data;

  # disable pytest_plugins which requires `pygeotile`
  preCheck = ''
    substituteInPlace tests/conftest.py \
      --replace "pytest_plugins" "_pytest_plugins"
  '';

  disabledTestPaths = [
    # Requires network access
    "tests/integration"
    # Missing requirements
    "tests/data"
  ];

  pythonImportsCheck = [
    "labelbox"
  ];

  meta = with lib; {
    description = "Platform API for LabelBox";
    homepage = "https://github.com/Labelbox/labelbox-python";
    changelog = "https://github.com/Labelbox/labelbox-python/blob/v.${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
