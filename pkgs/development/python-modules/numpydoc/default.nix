{ lib, buildPythonPackage, fetchPypi
, jinja2
, nose
, pytest
, sphinx
}:

buildPythonPackage rec {
  pname = "numpydoc";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "e481c0799dfda208b6a2c2cb28757fa6b6cbc4d6e43722173697996cf556df7f";
  };

  checkInputs = [ nose pytest ];
  propagatedBuildInputs = [ sphinx jinja2 ];

  meta = {
    description = "Sphinx extension to support docstrings in Numpy format";
    homepage = "https://github.com/numpy/numpydoc";
    license = lib.licenses.free;
   };
}
