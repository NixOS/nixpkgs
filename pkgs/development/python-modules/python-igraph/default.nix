{ buildPythonPackage, fetchPypi, lib, isPy3k
, pkgconfig, igraph }:

buildPythonPackage rec {
  pname = "python-igraph";
  version = "0.8.2";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ igraph ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "4601638d7d22eae7608cdf793efac75e6c039770ec4bd2cecf76378c84ce7d72";
  };

  doCheck = !isPy3k;

  meta = {
    description = "High performance graph data structures and algorithms";
    homepage = "https://igraph.org/python/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
