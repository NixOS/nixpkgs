{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "oset";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "017rr1m72s2fh9bmz5vrvc5mshczgzisi5894v9zkvvfr7gdf7sc";
  };

  doCheck = false;

  meta = {
    description = "Ordered set";
    license = lib.licenses.psfl;
  };
}
