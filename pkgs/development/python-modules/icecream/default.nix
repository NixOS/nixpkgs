{ lib, buildPythonPackage, fetchPypi
, asttokens, colorama, executing, pygments
}:

buildPythonPackage rec {
  pname = "icecream";
  version = "2.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CqSnwzdOw2FTodCPgeMIDoPYrB7v2X0vT+lUTo+bSd4=";
  };

  propagatedBuildInputs = [ asttokens colorama executing pygments ];

  meta = with lib; {
    description = "A little library for sweet and creamy print debugging";
    homepage = "https://github.com/gruns/icecream";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
