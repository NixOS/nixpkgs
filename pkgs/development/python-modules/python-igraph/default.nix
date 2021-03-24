{ buildPythonPackage, fetchPypi, lib, isPy3k
, pkg-config, igraph
, texttable }:

buildPythonPackage rec {
  pname = "python-igraph";
  version = "0.9.0";
  disabled = !isPy3k; # fails to build

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ igraph ];
  propagatedBuildInputs = [ texttable ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "7aa1d77fa02e27475eb4f14503f3cb342c3ed8990d9224640fd29c70797f2dd6";
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
