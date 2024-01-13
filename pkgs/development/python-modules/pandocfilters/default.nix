{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.5.0";
  format = "setuptools";
  pname = "pandocfilters";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b679503337d233b4339a817bfc8c50064e2eff681314376a47cb582305a7a38";
  };

  # No tests available
  doCheck = false;

  meta = with lib; {
    description = "A python module for writing pandoc filters, with a collection of examples";
    homepage = "https://github.com/jgm/pandocfilters";
    license = licenses.mit;
  };

}
