{ lib, buildPythonPackage, fetchPypi
, jinja2
, nose
, pytest
, sphinx
}:

buildPythonPackage rec {
  pname = "numpydoc";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "9140669e6b915f42c6ce7fef704483ba9b0aaa9ac8e425ea89c76fe40478f642";
  };

  checkInputs = [ nose pytest ];
  propagatedBuildInputs = [ sphinx jinja2 ];

  meta = {
    description = "Sphinx extension to support docstrings in Numpy format";
    homepage = "https://github.com/numpy/numpydoc";
    license = lib.licenses.free;
   };
}
