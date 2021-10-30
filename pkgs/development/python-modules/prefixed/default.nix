{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prefixed";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca48277ba5fa8346dd4b760847da930c7b84416387c39e93affef086add2c029";
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
