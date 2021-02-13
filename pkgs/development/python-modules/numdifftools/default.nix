{ buildPythonPackage
, lib
, pytestpep8
, pytestrunner
, fetchPypi
, numpy
, scipy
, statsmodels
, algopy
, hypothesis
, line_profiler
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "numdifftools";
  version = "0.9.39";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b1l8kpsw7qbxykcd0zl7gizvb36ij2fpxj4r937r6b56v2paz12";
  };

  # Required to build
  buildInputs = [ pytestrunner ];

  propagatedBuildInputs = [ numpy scipy algopy statsmodels ];

  checkInputs = [ hypothesis pytestpep8 line_profiler pytestCheckHook ];

  meta = with lib; {
    description = "Solves automatic numerical differentiation problems in one or more variables";
    maintainers = with maintainers; [ arthus ];
    homepage = "https://github.com/pbrod/numdifftools/";
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
