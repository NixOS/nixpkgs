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
    sha256 = "0pd71wxqjvznx10brsj1sgy3420bz7awbzk9jlj422rrdxql754j";
  };

  meta = {
    description = "Control LimitlessLED products";
    homepage = "https://github.com/happyleavesaoc/python-limitlessled/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sephalon ];
  };
}
