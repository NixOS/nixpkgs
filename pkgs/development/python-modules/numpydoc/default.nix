{ lib
, buildPythonPackage
, fetchPypi
, nose
, sphinx
, jinja2
}:

buildPythonPackage rec {
  pname = "numpydoc";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "61f4bf030937b60daa3262e421775838c945dcdd671f37b69e8e4854c7eb5ffd";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ sphinx jinja2 ];

  meta = {
    description = "Sphinx extension to support docstrings in Numpy format";
    homepage = "https://github.com/numpy/numpydoc";
    license = lib.licenses.free;
   };
}