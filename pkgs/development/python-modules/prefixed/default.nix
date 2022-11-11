{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prefixed";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-z5awVvmKubphXQMR7Kg3s9oBIBXNxZTz/uJIyvcCKLc=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "prefixed" ];

  meta = with lib; {
    description = "Prefixed alternative numeric library";
    homepage = "https://github.com/Rockhopper-Technologies/prefixed";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
