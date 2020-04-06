{ buildPythonPackage, fetchPypi, lib, isPy3k
, pkgconfig, igraph }:

buildPythonPackage rec {
  pname = "python-igraph";
  version = "0.7.1.post6";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ igraph ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xp61zz710qlzhmzbfr65d5flvsi8zf2xy78s6rsszh719wl5sm5";
  };

  doCheck = !isPy3k;

  meta = {
    description = "High performance graph data structures and algorithms";
    homepage = "https://igraph.org/python/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
