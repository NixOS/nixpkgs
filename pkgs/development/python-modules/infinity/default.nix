{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "infinity";
  version = "1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jap8Fc4hAP3M/eISM34M1c8IWGn1TcJjS2ww1hRh7No=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  meta = with lib; {
    description = "All-in-one infinity value for Python. Can be compared to any object";
    homepage = "https://github.com/kvesteri/infinity";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mupdt ];
  };
}
