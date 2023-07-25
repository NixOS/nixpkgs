{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, shapely
, python-dateutil
, pytz
, importlib-metadata
, numpy
, dateparser
, remotezip
, pytestCheckHook
, requests-mock
, defusedxml
}:

buildPythonPackage rec {
  pname = "asf-search";
  version = "6.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asfadmin";
    repo = "Discovery-asf_search";
    rev = "refs/tags/v${version}";
    hash = "sha256-9mhb8PEpRdFjbPBZ/B8he/UcRSLryBQU0Dgjcii7LGY=";
  };

  propagatedBuildInputs = [
    requests
    shapely
    python-dateutil
    pytz
    importlib-metadata
    numpy
    dateparser
    remotezip
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    requests-mock
    defusedxml
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
