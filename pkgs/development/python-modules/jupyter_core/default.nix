{ lib
, buildPythonPackage
, fetchPypi
, ipython
, traitlets
, glibcLocales
, mock
, pytest
, nose
}:

buildPythonPackage rec {
  pname = "jupyter_core";
  version = "4.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "394fd5dd787e7c8861741880bdf8a00ce39f95de5d18e579c74b882522219e7e";
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
