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
, jinja2
, remotezip
, pytestCheckHook
, requests-mock
, defusedxml
}:

buildPythonPackage rec {
  pname = "asf-search";
  version = "6.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asfadmin";
    repo = "Discovery-asf_search";
    rev = "refs/tags/v${version}";
    hash = "sha256-kbeIGIn8HMXROPiQSmwx3lo7wEX8SDuHYgxh4ws89Mo=";
  };

  propagatedBuildInputs = [
    requests
    shapely
    python-dateutil
    pytz
    importlib-metadata
    numpy
    dateparser
    jinja2
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
    description = "Python wrapper for the ASF SearchAPI";
    homepage = "https://github.com/asfadmin/Discovery-asf_search";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bzizou ];
  };
}
