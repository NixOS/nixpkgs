{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "limitlessled";
  version = "1.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kpRDcW85C0EklWn+xdX5Cwgy/NNB6rxA6PZviTsPp10=";
  };

  meta = with lib; {
    description = "Control LimitlessLED products";
    homepage = "https://github.com/happyleavesaoc/python-limitlessled/";
    license = licenses.mit;
    maintainers = with maintainers; [ sephalon ];
  };
}
