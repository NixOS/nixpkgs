{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec{
  version = "1.4.1";
  pname = "pandocfilters";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec8bcd100d081db092c57f93462b1861bcfa1286ef126f34da5cb1d969538acd";
  };

  # No tests available
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A python module for writing pandoc filters, with a collection of examples";
    homepage = https://github.com/jgm/pandocfilters;
    license = licenses.mit;
  };

}
