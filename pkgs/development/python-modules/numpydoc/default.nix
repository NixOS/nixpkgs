{ lib, buildPythonPackage, fetchPypi
, jinja2
, nose
, pytest
, sphinx
}:

buildPythonPackage rec {
  pname = "numpydoc";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "09x6l1a4dcvj7001bvcmcayg1nwqwhaxlwbp6kzj9qrk57lqx3z0";
  };

  checkInputs = [ nose pytest ];
  propagatedBuildInputs = [ sphinx jinja2 ];

  meta = {
    description = "Sphinx extension to support docstrings in Numpy format";
    homepage = "https://github.com/numpy/numpydoc";
    license = lib.licenses.free;
   };
}
