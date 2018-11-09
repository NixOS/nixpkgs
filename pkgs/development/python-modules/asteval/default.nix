{ stdenv
, buildPythonPackage
, fetchPypi
, numpy
, six
, pytest
}:

buildPythonPackage rec {
  pname = "asteval";
  version = "0.9.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8faf9f92b2b0d2ed376dc149d6bab2e01f614f6994722be9c16f982cbdd07c99";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy six ];

  checkPhase = ''
    pytest tests
  '';

  meta = with stdenv.lib; {
    description = "Safe, minimalistic evaluator of python expression using ast module";
    homepage = http://github.com/newville/asteval;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
