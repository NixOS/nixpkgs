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
  version = "2.1.3";

  disabled = isPy27; # uses python3 imports

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0aeg5kJ9CkFWx5LILK8fAQlgP2is55LjbKRZb9LLjZ0=";
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
