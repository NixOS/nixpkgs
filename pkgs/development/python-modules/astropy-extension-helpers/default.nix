{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "extension-helpers";
  version = "0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10iqjzmya2h4sk765dlm1pbqypwlqyh8rw59a5m9i63d3klnz2mc";
  };

  patches = [ ./permissions.patch ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "extension_helpers"
  ];

  meta = with lib; {
    description = "Utilities for building and installing packages in the Astropy ecosystem";
    homepage = "https://github.com/astropy/extension-helpers";
    license = licenses.bsd3;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
