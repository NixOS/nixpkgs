{ lib
, buildPythonPackage
, fetchPypi
, pytest
, click
, isPy3k
, futures
}:

buildPythonPackage rec {
  pname = "click-threading";
  version = "0.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2b0fada5bf184b56afaccc99d0d2548d8ab07feb2e95e29e490f6b99c605de7";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ click ] ++ lib.optional (!isPy3k) futures;

  checkPhase = ''
    py.test
  '';

  # Tests are broken on 3.x
  doCheck = !isPy3k;

  meta = {
    homepage = https://github.com/click-contrib/click-threading/;
    description = "Multithreaded Click apps made easy";
    license = lib.licenses.mit;
  };
}