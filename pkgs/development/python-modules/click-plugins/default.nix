{ stdenv, buildPythonPackage, fetchPypi,
  click, pytest
}:

buildPythonPackage rec {
  pname = "click-plugins";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ifphgaw5mmcdnqd0qfnmrbm62q3k6p573aff4cxgpyjxmz5xk3s";
  };

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [
    pytest
  ];

  meta = with stdenv.lib; {
    description = "An extension module for click to enable registering CLI commands";
    homepage = https://github.com/click-contrib/click-plugins;
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
