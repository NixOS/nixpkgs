{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, isPy27
, mock
, nose
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dpath";
  version = "2.0.2";

  disabled = isPy27; # uses python3 imports

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BA2+ShAeG2sbZenaJYU08PCwrgCjsf0tWS/oV5/4N64=";
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
