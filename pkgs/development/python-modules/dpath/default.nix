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
  version = "2.0.5";

  disabled = isPy27; # uses python3 imports

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kk7wl15r305496q13ka4r6n2r13j99rrrpy2b4575j704dk4x7g";
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
