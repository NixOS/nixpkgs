{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pythonOlder
, mock
, nose2
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "dpath";
  version = "2.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zNlk24ObqtSqggYStLhzGwn0CiRdQBtyMVbOTvRbIrc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    hypothesis
    mock
    nose2
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dpath"
  ];

  meta = with lib; {
    description = "Python library for accessing and searching dictionaries via /slashed/paths ala xpath";
    homepage = "https://github.com/akesterson/dpath-python";
    changelog = "https://github.com/dpath-maintainers/dpath-python/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mmlb ];
  };
}
