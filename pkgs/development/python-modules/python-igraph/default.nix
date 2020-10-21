{ buildPythonPackage, fetchPypi, lib, isPy3k
, pkgconfig, igraph
, texttable }:

buildPythonPackage rec {
  pname = "python-igraph";
  version = "0.8.3";
  disabled = !isPy3k; # fails to build

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ igraph ];
  propagatedBuildInputs = [ texttable ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1f27622eddeb2bd5fdcbadb41ef048e884790bb050f9627c086dc609d0f1236";
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
