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
  version = "4.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a183e0ec2e8f6adddf62b0a3fc6a2237e3e0056d381e536d3e7c7ecc3067e244";
  };

  checkInputs = [ pytest mock glibcLocales nose ];
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
