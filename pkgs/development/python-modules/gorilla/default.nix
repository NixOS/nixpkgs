{ lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "gorilla";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "005ab8853b037162a7c77bb824604c6e081878ee03c09ad01ef41744856019d3";
  };

  meta = with lib; {
    homepage = "https://github.com/christophercrouzet/gorilla";
    description = "Convenient approach to monkey patching";
    license = licenses.mit;
    maintainers = with maintainers; [ tbenst ];
  };
}
