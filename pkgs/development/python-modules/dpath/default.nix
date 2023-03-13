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
  version = "2.1.4";

  disabled = isPy27; # uses python3 imports

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-M4CnfQ20q/EEElhg/260vQfJfGW4Gq1CpglxcImhvtA=";
  };

  # use pytest as nosetests hangs
  nativeCheckInputs = [
    hypothesis
    mock
    nose2
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
