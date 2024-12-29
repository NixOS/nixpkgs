{
  lib,
  arrow,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  pytestCheckHook,
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
    hash = "sha256-WVWGhyBguE1+KEMQu0N5QxO7IC4rPEJ/2L3VWUCQNi4=";
  };

  patches = [
    (fetchpatch {
      name = "remove-unittest2.patch";
      url = "https://github.com/nickmaccarthy/python-datemath/commit/781daa0241ed327d5f211f3b62f553f3ee3d86e0.patch";
      hash = "sha256-WD6fuDaSSNXgYWoaUexiWnofCzEZzercEUlqTvOUT5I=";
    })
  ];

  propagatedBuildInputs = [ arrow ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "datemath" ];

  meta = with lib; {
    description = "Python module to emulate the date math used in SOLR and Elasticsearch";
    homepage = "https://github.com/nickmaccarthy/python-datemath";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
