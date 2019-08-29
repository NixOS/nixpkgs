{ stdenv, buildPythonPackage, fetchPypi,
  click, pytest
}:

buildPythonPackage rec {
  pname = "click-plugins";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfed74b5063546a137de99baaaf742b4de4337ad2b3e1df5ec7c8a256adc0847";
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
