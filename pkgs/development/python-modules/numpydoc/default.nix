{ lib, buildPythonPackage, fetchPypi, isPy27
, jinja2
, nose
, pytest
, sphinx
}:

buildPythonPackage rec {
  pname = "numpydoc";
  version = "1.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "sha256-DOwjN0DGsSWRMAXRboqZluBgUor8uLfK0/JwZinf1vc=";
  };

  checkInputs = [ nose pytest ];
  propagatedBuildInputs = [ sphinx jinja2 ];

  meta = {
    description = "Sphinx extension to support docstrings in Numpy format";
    homepage = "https://github.com/numpy/numpydoc";
    license = lib.licenses.free;
   };
}
