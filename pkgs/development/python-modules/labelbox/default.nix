{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, geojson
, google-api-core
, imagesize
, nbconvert
, nbformat
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
  version = "3.52.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Labelbox";
    repo = "labelbox-python";
    rev = "refs/tags/v.${version}";
    hash = "sha256-t0Q+6tnUPK2oqjdAwwYeSebgn2EQ1fBivw115L8ndOg=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--reruns 5 --reruns-delay 10" ""
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

  nativeCheckInputs = [
    nbconvert
    nbformat
    pytest-cases
    pytestCheckHook
  ] ++ passthru.optional-dependencies.data;

  disabledTestPaths = [
    # Requires network access
    "tests/integration"
    # Missing requirements
    "tests/data"
  ];

  pytestFlagsArray = [
    # see tox.ini
    "-k 'not notebooks'"
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
