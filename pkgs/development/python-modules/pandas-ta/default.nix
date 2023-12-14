{ lib, stdenv, buildPythonPackage, pythonOlder, fetchPypi, setuptools
, pytestCheckHook, pandas }:

buildPythonPackage rec {
  pname = "pandas_ta";
  version = "0.3.14b";
  pyproject = true;

  disabled = pythonOlder "3.10";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D6Na7IMdKBXqMLhxaIqNIKdrKIp74tJswAw1zYwJqZM=";
  };

  nativeBuildInputs = [ setuptools pandas ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pandas_ta" ];

  meta = with lib; {
    changelog =
      "https://github.com/twopirllc/pandas-ta/releases/tag/${version}";
    description =
      "Pandas TA is an easy to use Python 3 Pandas Extension with 130+ Indicators";
    homepage = "https://github.com/twopirllc/pandas-ta";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
