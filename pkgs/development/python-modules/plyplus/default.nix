{
  lib,
  fetchPypi,
  buildPythonPackage,
  ply,
  isPy3k,
}:
buildPythonPackage rec {
  pname = "plyplus";
  version = "0.7.5";
  format = "setuptools";

  src = fetchPypi {
    pname = "PlyPlus";
    inherit version;
    hash = "sha256-116oDNCsbOjo/kMzEDJu/RXF+KoY/LRRE+vKUd2jbjw=";
  };

  propagatedBuildInputs = [ ply ];

  doCheck = !isPy3k;

  meta = {
    homepage = "https://github.com/erezsh/plyplus";
    description = "General-purpose parser built on top of PLY";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
