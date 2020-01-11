{ stdenv, buildPythonPackage, fetchPypi,
  click, pytest
}:

buildPythonPackage rec {
  pname = "click-plugins";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b";
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
