{ lib
, buildPythonApplication
, fetchPypi
}:

buildPythonApplication rec {
  pname = "filecheck";
  version = "0.0.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ae4ye2t0LO0v2eRDGdLXBqRXPl4O5yYZONDeFqd+XAY=";
  };

  pythonImportsCheck = [ "filecheck" ];

  meta = with lib; {
    homepage = "https://github.com/mull-project/FileCheck.py";
    license = licenses.asl20;
    description = "Python port of LLVM's FileCheck, flexible pattern matching file verifier";
    maintainers = with maintainers; [ yorickvp ];
  };
}
