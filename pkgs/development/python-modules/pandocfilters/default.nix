{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.4.3";
  pname = "pandocfilters";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc63fbb50534b4b1f8ebe1860889289e8af94a23bff7445259592df25a3906eb";
  };

  # No tests available
  doCheck = false;

  meta = with lib; {
    description = "A python module for writing pandoc filters, with a collection of examples";
    homepage = "https://github.com/jgm/pandocfilters";
    license = licenses.mit;
  };

}
