{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gamble";
  version = "0.10";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lb5x076blnnz2hj7k92pyq0drbjwsls6pmnabpvyvs4ddhz5w9w";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gamble"
  ];

  meta = with lib; {
    description = "Collection of gambling classes/tools";
    homepage = "https://github.com/jpetrucciani/gamble";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
