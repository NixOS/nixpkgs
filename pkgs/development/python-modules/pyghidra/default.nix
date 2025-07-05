{
  lib,
  buildPythonPackage,
  fetchPypi,
  jpype1,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyghidra";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ql9aJmh2uR2XqtmhfaaoXjg+ow46McLwUInegplGr7A=";
  };

  build-system = [ setuptools ];

  dependencies = [ jpype1 ];

  pythonImportsCheck = [ "pyghidra" ];

  meta = with lib; {
    description = "Enables Ghidra GUI and headless Ghidra to run scripts written in native CPython 3, as well as interact with the Ghidra GUI through a builtin-REPL";
    homepage = "https://github.com/NationalSecurityAgency/ghidra/tree/master/Ghidra/Features/PyGhidra";
    license = licenses.asl20;
    maintainers = with maintainers; [ cything ];
  };
}
