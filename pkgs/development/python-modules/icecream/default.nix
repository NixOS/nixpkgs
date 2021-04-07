{ lib, buildPythonPackage, fetchPypi
, asttokens, colorama, executing, pygments
}:

buildPythonPackage rec {
  pname = "icecream";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2e7b74c1c12caa2cfde050f2e636493ee77a9fb4a494b5593418ab359924a24";
  };

  propagatedBuildInputs = [ asttokens colorama executing pygments ];

  meta = with lib; {
    description = "A little library for sweet and creamy print debugging";
    homepage = "https://github.com/gruns/icecream";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
