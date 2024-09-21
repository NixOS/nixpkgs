{
  lib,
  buildPythonPackage,
  cachetools,
  coloredlogs,
  fetchPypi,
  pythonOlder,
  pytz,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "locationsharinglib";
  version = "5.0.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ar5/gyDnby0aceqqHe8lTQaHafOub+IPKglmct4xEGM=";
  };

  postPatch = ''
    # Tests requirements want to pull in multiple modules which we don't need
    substituteInPlace setup.py \
      --replace-fail "tests_require=test_requirements" "tests_require=[]"
    cp .VERSION locationsharinglib/.VERSION
  '';

  build-system = [ setuptools ];

  dependencies = [
    coloredlogs
    requests
    cachetools
    pytz
  ];

  # There are no tests
  doCheck = false;

  pythonImportsCheck = [ "locationsharinglib" ];

  meta = {
    description = "Python package to retrieve coordinates from a Google account";
    homepage = "https://locationsharinglib.readthedocs.io/";
    changelog = "https://github.com/costastf/locationsharinglib/blob/${version}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
