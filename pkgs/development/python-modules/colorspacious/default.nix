{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
}:

buildPythonPackage rec {
  pname = "colorspacious";
  version = "1.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "065n24zbm9ymy2gvf03vx5cggk1258vcjdaw8jn9v26arpl7542y";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    homepage = "https://github.com/njsmith/colorspacious";
    description = "Powerful, accurate, and easy-to-use Python library for doing colorspace conversions";
    license = licenses.mit;
    maintainers = with maintainers; [ tbenst ];
  };
}
