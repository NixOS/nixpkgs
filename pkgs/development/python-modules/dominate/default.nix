{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "dominate";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1775cz6lipb43hmjll77m2pxh72pikng74lpg30v9n1b66s78959";
  };

  doCheck = !isPy3k;

  meta = with lib; {
    homepage = https://github.com/Knio/dominate/;
    description = "Dominate is a Python library for creating and manipulating HTML documents using an elegant DOM API";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
