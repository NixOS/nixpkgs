{ lib
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, isPy27
, mock
, nose
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dpath";
  version = "2.0.5";

  disabled = isPy27; # uses python3 imports

  src = fetchFromGitHub {
     owner = "akesterson";
     repo = "dpath-python";
     rev = "v2.0.5";
     sha256 = "1ga5k3phgn6kmg41m33w3w65vdwnsil3r1y4a6wlhgsnxci5n4vl";
  };

  # use pytest as nosetests hangs
  checkInputs = [
    hypothesis
    mock
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dpath" ];

  meta = with lib; {
    description = "Python library for accessing and searching dictionaries via /slashed/paths ala xpath";
    homepage = "https://github.com/akesterson/dpath-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mmlb ];
  };
}
