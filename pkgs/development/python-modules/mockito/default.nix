{ lib, buildPythonPackage, fetchPypi, isPy3k, funcsigs, pytest, numpy }:

buildPythonPackage rec {
  version = "1.3.1";
  pname = "mockito";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-o8Hg3UnxWbJITBu/IjsbWRHDiJ5smffKUNHAqG21170=";
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
