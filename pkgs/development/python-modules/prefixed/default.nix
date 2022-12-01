{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prefixed";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sTTXNBNiULF7aO7eZaM3D6sBNEEstmvIvjVo/wW9+OQ=";
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
