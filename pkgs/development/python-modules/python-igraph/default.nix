{ buildPythonPackage, fetchPypi, lib, isPy3k
, pkgconfig, igraph
, texttable }:

buildPythonPackage rec {
  pname = "python-igraph";
  version = "0.8.2";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ igraph ];
  propagatedBuildInputs = [ texttable ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "4601638d7d22eae7608cdf793efac75e6c039770ec4bd2cecf76378c84ce7d72";
  };

  # NB: We want to use our igraph, not vendored igraph, but even with
  # pkg-config on the PATH, their custom setup.py still needs to be explicitly
  # told to do it. ~ C.
  setupPyGlobalFlags = [ "--use-pkg-config" ];

  doCheck = !isPy3k;

  meta = {
    description = "High performance graph data structures and algorithms";
    homepage = "https://igraph.org/python/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
