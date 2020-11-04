{ stdenv, buildPythonPackage, fetchPypi, isPy3k, funcsigs, pytest, numpy }:

buildPythonPackage rec {
  version = "1.2.2";
  pname = "mockito";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6b3aca6cdb92bbd47e19ebdb1a0b84ef23ab874eae5c6d505323c8657257c06";
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
