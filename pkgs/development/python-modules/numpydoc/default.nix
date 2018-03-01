{ lib
, buildPythonPackage
, fetchPypi
, nose
, sphinx
, jinja2
}:

buildPythonPackage rec {
  pname = "numpydoc";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "2dc7b2c4e3914745e38e370946fa4c109817331e6d450806285c08bce5cd575a";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ sphinx jinja2 ];

  meta = {
    description = "Sphinx extension to support docstrings in Numpy format";
    homepage = "https://github.com/numpy/numpydoc";
    license = lib.licenses.free;
   };
}