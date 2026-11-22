{
  buildPythonPackage,
  fetchPypi,
  lib,
  pandocfilters,
}:

buildPythonPackage rec {
  pname = "pandoc-attributes";
  version = "0.1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aSIVAtrHT13xMXARzmLIWoPu9do7ccY7GQjpgiQwSow=";
  };

  propagatedBuildInputs = [ pandocfilters ];

  # No tests in pypi source
  doCheck = false;

  meta = {
    homepage = "https://github.com/aaren/pandoc-attributes";
    description = "Attribute class to be used with pandocfilters";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ vcanadi ];
  };
}
