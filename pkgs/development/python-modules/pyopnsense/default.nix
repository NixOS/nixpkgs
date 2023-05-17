{ lib
, buildPythonPackage
, fetchPypi
, fixtures
, mock
, pbr
, pytest-cov
, pytestCheckHook
, pythonOlder
, requests
, six
}:

buildPythonPackage rec {
  pname = "pyopnsense";
  version = "0.3.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06rssdb3zhccnm63z96mw5yd38d9i99fgigfcdxn9divalbbhp5a";
  };

  propagatedBuildInputs = [
    pbr
    six
    requests
  ];

  nativeCheckInputs = [
    fixtures
    mock
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyopnsense" ];

  meta = with lib; {
    description = "Python client for the OPNsense API";
    homepage = "https://github.com/mtreinish/pyopnsense";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
