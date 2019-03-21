{ lib
, buildPythonPackage
, fetchPypi
, six
, enum34
}:

buildPythonPackage rec {
  pname = "gin-config";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07843fde2917f1a44f808fceb3c0227bb02ff7c4ebba8de6642206c03e7e8ba2";

  };

  propagatedBuildInputs = [ six enum34 ];

  # PyPI archive does not ship with tests
  doCheck= false;

  meta = with lib; {
    homepage = https://github.com/google/gin-config;
    description = "Gin provides a lightweight configuration framework for Python, based on dependency injection.";
    license = licenses.asl20;
    maintainers = with maintainers; [ jethro ];
  };
}
