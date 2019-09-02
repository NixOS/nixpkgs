{ lib
, buildPythonPackage
, fetchPypi
, ipython
, traitlets
, glibcLocales
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "jupyter_core";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xr4pbghwk5hayn5wwnhb7z95380r45p79gf5if5pi1akwg7qvic";
  };

  checkInputs = [ pytest mock glibcLocales ];
  propagatedBuildInputs = [ ipython traitlets ];

  patches = [ ./tests_respect_pythonpath.patch ];

  checkPhase = ''
    HOME=$TMPDIR LC_ALL=en_US.utf8 py.test
  '';

  meta = with lib; {
    description = "Jupyter core package. A base package on which Jupyter projects rely";
    homepage = https://jupyter.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
