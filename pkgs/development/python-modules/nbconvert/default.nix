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
, nbconvert
, ipykernel
, pandocfilters
, tornado
, jupyter_client
}:

buildPythonPackage rec {
  pname = "nbconvert";
  version = "5.3.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f9dkvpx186xjm4xab0qbph588mncp4vqk3fmxrsnqs43mks9c8j";
  };

  checkInputs = [ nose pytest glibcLocales ];

  propagatedBuildInputs = [
    entrypoints bleach mistune jinja2 pygments traitlets testpath
    jupyter_core nbformat ipykernel pandocfilters tornado jupyter_client
  ];

  checkPhase = ''
    mkdir tmp
    LC_ALL=en_US.utf8 HOME=`realpath tmp` py.test -v
  '';

  meta = {
    description = "Converting Jupyter Notebooks";
    homepage = http://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh globin ];
  };
}
