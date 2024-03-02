{ lib
, buildPythonPackage
, fetchPypi
, pytest
, click
, isPy3k
, futures ? null
}:

buildPythonPackage rec {
  pname = "click-threading";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rc/mI8AqWVwQfDFAcvZ6Inj+TrQLcsDRoskDzHivNDk=";
  };

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [ click ] ++ lib.optional (!isPy3k) futures;

  checkPhase = ''
    py.test
  '';

  # Tests are broken on 3.x
  doCheck = !isPy3k;

  meta = {
    homepage = "https://github.com/click-contrib/click-threading/";
    description = "Multithreaded Click apps made easy";
    license = lib.licenses.mit;
  };
}
