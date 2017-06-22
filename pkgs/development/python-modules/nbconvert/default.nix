{ lib
, buildPythonPackage
, fetchPypi
, pytest
, nose
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
  version = "5.2.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ed68ec7fe90a8672b43795b29ea91cc75ea355c83debc83ebd12171521ec274";
  };

  checkInputs = [ nose pytest ];

  propagatedBuildInputs = [
    entrypoints bleach mistune jinja2 pygments traitlets testpath
    jupyter_core nbformat ipykernel pandocfilters tornado jupyter_client
  ];

  checkPhase = ''
    nosetests -v
  '';

  # PermissionError. Likely due to being in a chroot
  doCheck = false;

  meta = {
    description = "Converting Jupyter Notebooks";
    homepage = http://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
