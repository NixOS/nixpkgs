{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, isPy27
, mock
, nose2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dpath";
  version = "2.1.5";

  disabled = isPy27; # uses python3 imports

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zNlk24ObqtSqggYStLhzGwn0CiRdQBtyMVbOTvRbIrc=";
  };

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
