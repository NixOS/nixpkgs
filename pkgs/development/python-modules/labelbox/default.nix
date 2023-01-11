{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, geojson
, google-api-core
, imagesize
, ndjson
, numpy
, opencv
  # , opencv-python
, packaging
, pillow
, pydantic
  # , pygeotile
, pyproj
, pytest-cases
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, rasterio
, requests
, shapely
, tqdm
, typeguard
, typing-extensions
}:

buildPythonPackage rec {
  pname = "labelbox";
  version = "3.34.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Labelbox";
    repo = "labelbox-python";
    rev = "refs/tags/v.${version}";
    hash = "sha256-x/XvcGiFS//f/le3JAd2n/tuUy9MBrCsISpkIkCCNis=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "-s -vv -x --reruns 5 --reruns-delay 10 --durations=20" "-s -vv -x --durations=20"
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "backoff"
  ];

  propagatedBuildInputs = [
    backoff
    google-api-core
    ndjson
    pydantic
    requests
    tqdm
  ];

  passthru.optional-dependencies = {
    data = [
      shapely
      geojson
      numpy
      pillow
      # opencv-python
      typeguard
      imagesize
      pyproj
      # pygeotile
      typing-extensions
      packaging
    ];
  };

  checkInputs = [
    pytest-cases
    pytestCheckHook
  ] ++ passthru.optional-dependencies.data;

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
