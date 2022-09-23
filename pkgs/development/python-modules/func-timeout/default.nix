{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "func-timeout";
  version = "4.3.5";

  src = fetchPypi {
    pname = "func_timeout";
    inherit version;
    sha256 = "74cd3c428ec94f4edfba81f9b2f14904846d5ffccc27c92433b8b5939b5575dd";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "func_timeout" ];

  meta = with lib; {
    description = "Allows you to specify timeouts when calling any existing function. Also provides support for stoppable-threads";
    homepage = "https://github.com/kata198/func_timeout";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
