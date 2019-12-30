{ stdenv, buildPythonPackage, fetchPypi, isPy3k, funcsigs, pytest, numpy }:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "mockito";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a1cbae9d0aef4ae7586b03f2a463e8c5ba96aa937c0535ced4a5621f851feeb";
  };

  propagatedBuildInputs = stdenv.lib.optionals (!isPy3k) [ funcsigs ];
  checkInputs = [ pytest numpy ];

  # tests are no longer packaged in pypi tarball
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "Spying framework";
    homepage = https://github.com/kaste/mockito-python;
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
