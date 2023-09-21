{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

let
  pname = "py3rijndael";
  version = "0.3.3";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tmVaPr/zoQVA6u0EnoeI7qOsk9a3GzpqwrACJLvs6ag=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Rijndael algorithm library";
    homepage = "https://github.com/meyt/py3rijndael";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
