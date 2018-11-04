{ lib
, buildPythonPackage
, fetchPypi
, pytest
, nose
, glibcLocales
, entrypoints
, bleach
, mistune
, jinja2
, pygments
, traitlets
, testpath
, jupyter_core
, nbformat
, ipykernel
, pandocfilters
, tornado
, jupyter_client
}:

buildPythonPackage rec {
  pname = "nbconvert";
  version = "5.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a8a2749f972592aa9250db975304af6b7337f32337e523a2c995cc9e12c07807";
  };

  checkInputs = [ nose pytest glibcLocales ];

  propagatedBuildInputs = [
    entrypoints bleach mistune jinja2 pygments traitlets testpath
    jupyter_core nbformat ipykernel pandocfilters tornado jupyter_client
  ];

  checkPhase = ''
    mkdir tmp
    LC_ALL=en_US.UTF-8 HOME=`realpath tmp` py.test -v
  '';

  meta = {
    description = "Converting Jupyter Notebooks";
    homepage = http://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh globin ];
  };
}
