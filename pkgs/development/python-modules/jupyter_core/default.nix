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
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ba70754aa680300306c699790128f6fbd8c306ee5927976cbe48adacf240c0b7";
  };

  checkInputs = [ pytest mock glibcLocales ];
  propagatedBuildInputs = [ ipython traitlets ];

  patches = [ ./tests_respect_pythonpath.patch ];

  checkPhase = ''
    mkdir tmp
    HOME=tmp TMPDIR=tmp LC_ALL=en_US.utf8 py.test
  '';

  meta = with lib; {
    description = "Jupyter core package. A base package on which Jupyter projects rely";
    homepage = https://jupyter.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh globin ];
  };
}
