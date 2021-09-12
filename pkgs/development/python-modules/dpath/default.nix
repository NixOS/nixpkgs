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
  version = "2.0.4";

  disabled = isPy27; # uses python3 imports

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qjaa4sjw0m4b91mm18074wpkhir3xx7s87qwckmzpfb165gk837";
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
