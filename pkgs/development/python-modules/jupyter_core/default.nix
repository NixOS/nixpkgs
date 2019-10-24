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
  version = "4.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "85103cee6548992780912c1a0a9ec2583a4a18f1ef79a248ec0db4446500bce3";
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
