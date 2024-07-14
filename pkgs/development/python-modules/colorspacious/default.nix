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
    hash = "sha256-XpBy6M3KiJ2sRFw1yTYqIsz3WOl7ALef8NWnuj4Rthg=";
  };

  propagatedBuildInputs = [ numpy ];

  meta = {
    homepage = "https://github.com/njsmith/colorspacious";
    description = "Powerful, accurate, and easy-to-use Python library for doing colorspace conversions ";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
