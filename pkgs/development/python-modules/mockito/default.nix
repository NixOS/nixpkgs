{ stdenv, buildPythonPackage, fetchPypi, isPy3k, funcsigs, pytest, numpy }:

buildPythonPackage rec {
  version = "1.1.1";
  pname = "mockito";

  src = fetchPypi {
    inherit pname version;
    sha256 = "142f5e8865a422ad2d67b9c67a382e3296e8f1633dbccd0e322180fba7d5303d";
  };

  # Failing tests due 2to3
  doCheck = !isPy3k;

  propagatedBuildInputs = stdenv.lib.optionals (!isPy3k) [ funcsigs ];
  checkInputs = [ pytest numpy ];

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
