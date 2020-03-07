{ lib, pkgs, buildPythonPackage, fetchPypi, isPy3k
, numpy
}:

buildPythonPackage rec {
  pname = "colorspacious";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "065n24zbm9ymy2gvf03vx5cggk1258vcjdaw8jn9v26arpl7542y";
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = {
    homepage = "https://github.com/njsmith/colorspacious";
    description = "A powerful, accurate, and easy-to-use Python library for doing colorspace conversions ";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
