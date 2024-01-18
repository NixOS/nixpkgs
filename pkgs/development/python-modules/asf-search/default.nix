{ lib
, buildPythonPackage
, dateparser
, defusedxml
, fetchFromGitHub
, importlib-metadata
, numpy
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, remotezip
, requests
, requests-mock
, shapely
, tenacity
}:

buildPythonPackage rec {
  pname = "asf-search";
  version = "6.7.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asfadmin";
    repo = "Discovery-asf_search";
    rev = "refs/tags/v${version}";
    hash = "sha256-wtsPnppsW44OdvdkkuyPoqADzpecUytXEc6G4q7HEw0=";
  };

  propagatedBuildInputs = [
    dateparser
    importlib-metadata
    numpy
    python-dateutil
    pytz
    remotezip
    requests
    shapely
  ];

  nativeCheckInputs = [
    defusedxml
    pytestCheckHook
    requests-mock
    tenacity
  ];

  pythonImportsCheck = [
    "asf_search"
  ];

  meta = with lib; {
    changelog = "https://github.com/asfadmin/Discovery-asf_search/blob/${src.rev}/CHANGELOG.md";
    description = "Python wrapper for the ASF SearchAPI";
    homepage = "https://github.com/asfadmin/Discovery-asf_search";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bzizou ];
  };
}
