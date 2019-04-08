{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec{
  version = "1.4.2";
  pname = "pandocfilters";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3dd70e169bb5449e6bc6ff96aea89c5eea8c5f6ab5e207fc2f521a2cf4a0da9";
  };

  # No tests available
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A python module for writing pandoc filters, with a collection of examples";
    homepage = https://github.com/jgm/pandocfilters;
    license = licenses.mit;
  };

}
