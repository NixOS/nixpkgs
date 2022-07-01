{ lib
, arrow
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, unittest2
}:

buildPythonPackage rec {
  pname = "python-datemath";
  version = "1.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nickmaccarthy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WVWGhyBguE1+KEMQu0N5QxO7IC4rPEJ/2L3VWUCQNi4=";
  };

  propagatedBuildInputs = [
    arrow
  ];

  checkInputs = [
    pytestCheckHook
    unittest2
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  pythonImportsCheck = [
    "datemath"
  ];

  meta = with lib; {
    description = "Python module to emulate the date math used in SOLR and Elasticsearch";
    homepage = "https://github.com/nickmaccarthy/python-datemath";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
