{ lib, buildPythonPackage, fetchPypi, isPy27
, jinja2
, nose
, pytest
, sphinx
}:

buildPythonPackage rec {
  pname = "numpydoc";
  version = "1.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "c36fd6cb7ffdc9b4e165a43f67bf6271a7b024d0bb6b00ac468c9e2bfc76448e";
  };

  checkInputs = [ nose pytest ];
  requiredPythonModules = [ sphinx jinja2 ];

  meta = {
    description = "Sphinx extension to support docstrings in Numpy format";
    homepage = "https://github.com/numpy/numpydoc";
    license = lib.licenses.free;
   };
}
