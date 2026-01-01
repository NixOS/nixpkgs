{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  html5lib,
  jsonschema,
  pytest-cov-stub,
  pytest-mock,
  pytest-recording,
  python-dateutil,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pystac";
<<<<<<< HEAD
  version = "1.14.2";
=======
  version = "1.14.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "stac-utils";
    repo = "pystac";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lSwapIOoZfI9m7BRVQVD8DS7+N+zieOiuvgwflt/bZw=";
=======
    hash = "sha256-k2w/Se/XdPLZQ69TQkIomPsI6uiM+dO2H2HQ3fvPyF0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ python-dateutil ];

  nativeCheckInputs = [
    html5lib
    jsonschema
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
    pytest-recording
    requests-mock
  ];

  pythonImportsCheck = [ "pystac" ];

  meta = {
    description = "Python library for working with any SpatioTemporal Asset Catalog (STAC)";
    homepage = "https://github.com/stac-utils/pystac";
    license = lib.licenses.asl20;
    teams = [ lib.teams.geospatial ];
  };
}
