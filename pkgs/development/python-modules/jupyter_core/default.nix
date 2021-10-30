{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, ipython
, traitlets
, glibcLocales
, mock
, pytest
, nose
}:

buildPythonPackage rec {
  pname = "jupyter_core";
  version = "4.7.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "79025cb3225efcd36847d0840f3fc672c0abd7afd0de83ba8a1d3837619122b4";
  };

  checkInputs = [ pytest mock glibcLocales nose ];
  propagatedBuildInputs = [ ipython traitlets ];

  patches = [ ./tests_respect_pythonpath.patch ];

  checkPhase = ''
    HOME=$TMPDIR LC_ALL=en_US.utf8 py.test
  '';

  meta = with lib; {
    description = "Jupyter core package. A base package on which Jupyter projects rely";
    homepage = "https://jupyter.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
