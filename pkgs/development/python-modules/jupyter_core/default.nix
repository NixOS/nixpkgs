{ lib
, python
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
  version = "4.3.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a96b129e1641425bf057c3d46f4f44adce747a7d60107e8ad771045c36514d40";
  };

  buildInputs = [ pytest mock glibcLocales ];
  propagatedBuildInputs = [ ipython traitlets ];

  patches = [ ./tests_respect_pythonpath.patch ];

  checkPhase = ''
    mkdir tmp
    HOME=tmp TMPDIR=tmp LC_ALL=en_US.utf8 py.test
  '';

  meta = with lib; {
    description = "Jupyter core package. A base package on which Jupyter projects rely";
    homepage = http://jupyter.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh globin ];
  };
}
