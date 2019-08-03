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
    sha256 = "2c6e7c1e9f2ac45b5c2ceea5730bc9008d92fe59d0725eac57b04c0edfba24f7";
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
