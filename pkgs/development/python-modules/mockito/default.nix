{ stdenv, buildPythonPackage, fetchPypi, isPy3k, funcsigs, pytest, numpy }:

buildPythonPackage rec {
  version = "1.2.1";
  pname = "mockito";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ilj73bdk81v4l7ir6hbfvmslzbsxkgvz1asngbyf7w5gl2y5nyf";
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
    homepage = "https://github.com/kaste/mockito-python";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
