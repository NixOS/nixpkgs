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
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "400b0bb63d9096b6bf2806efaf742a1cc8b6c88e0484f0afe7d7a7f0e9870609";
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