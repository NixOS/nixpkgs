{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rzpipe";
  version = "0.1.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13z88c4zjy10a1sc98ba25sz200v6w2wprbq4iknm4sy2fmrsydh";
  };

  # No native rz_core library
  doCheck = false;

  pythonImportsCheck = [
    "rzpipe"
  ];

  meta = with lib; {
    description = "Python interface for rizin";
    homepage = "https://rizin.re";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
