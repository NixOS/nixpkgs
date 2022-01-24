{ lib, buildPythonPackage, fetchPypi, isPy3k, funcsigs, pytest, numpy }:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "mockito";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d41a5f6ec0b8fc32b6d796480d4849ee5fb0ac75d12f13862f1622684f5f578";
  };

  propagatedBuildInputs = lib.optionals (!isPy3k) [ funcsigs ];
  checkInputs = [ pytest numpy ];

  # tests are no longer packaged in pypi tarball
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Spying framework";
    homepage = "https://github.com/kaste/mockito-python";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
