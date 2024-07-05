{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.5.1";
  format = "setuptools";
  pname = "pandocfilters";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ACtKVV7k68A/i2Ywfih/pJLkp3tOoU0/k0MoKXu0k54=";
  };

  # No tests available
  doCheck = false;

  meta = with lib; {
    description = "Python module for writing pandoc filters, with a collection of examples";
    homepage = "https://github.com/jgm/pandocfilters";
    license = licenses.mit;
  };
}
