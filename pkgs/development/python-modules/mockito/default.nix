{ lib, buildPythonPackage, fetchPypi, isPy3k, funcsigs, pytest, numpy }:

buildPythonPackage rec {
  version = "1.4.0";
  format = "setuptools";
  pname = "mockito";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QJq2BMnr4bt9wY7GsO2YqK1RJ7CCc/WASyL00bUeUiI=";
  };

  propagatedBuildInputs = lib.optionals (!isPy3k) [ funcsigs ];
  nativeCheckInputs = [ pytest numpy ];

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
