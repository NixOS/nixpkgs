{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "limitlessled";
  version = "1.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-kpRDcW85C0EklWn+xdX5Cwgy/NNB6rxA6PZviTsPp10=";
  };

  meta = {
    description = "Control LimitlessLED products";
    homepage = "https://github.com/happyleavesaoc/python-limitlessled/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephalon ];
  };
})
