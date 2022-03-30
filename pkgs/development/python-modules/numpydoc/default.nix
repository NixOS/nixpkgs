{ lib, buildPythonPackage, fetchPypi, isPy27
, jinja2
, nose
, pytest
, sphinx
}:

buildPythonPackage rec {
  pname = "numpydoc";
  version = "1.2.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "sha256-fOgm7Q1Uw/3JCXmSqNc6TUWdxGhhE1HGjkRP7ESkWvY=";
  };

  checkInputs = [ nose pytest ];
  propagatedBuildInputs = [ sphinx jinja2 ];

  meta = {
    description = "Sphinx extension to support docstrings in Numpy format";
    homepage = "https://github.com/numpy/numpydoc";
    license = lib.licenses.free;
   };
}
