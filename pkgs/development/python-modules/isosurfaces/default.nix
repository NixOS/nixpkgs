{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
}:

buildPythonPackage rec {
  pname = "isosurfaces";
  version = "0.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+lHr6GTqk1WyaDDif91qQdWli0GfqNS0fjuLgHGNbiE=";
  };

  propagatedBuildInputs = [ numpy ];

  # no tests defined upstream
  doCheck = false;

  pythonImportsCheck = [ "isosurfaces" ];

  meta = with lib; {
    homepage = "https://github.com/jared-hughes/isosurfaces";
    description = "Construct isolines/isosurfaces of a 2D/3D scalar field defined by a function";
    longDescription = ''
      Construct isolines/isosurfaces of a 2D/3D scalar field defined by a
      function, i.e. curves over which f(x,y)=0 or surfaces over which
      f(x,y,z)=0. Most similar libraries use marching squares or similar over a
      uniform grid, but this uses a quadtree to avoid wasting time sampling
      many far from the implicit surface.
    '';
    license = licenses.mit;
    maintainers = [ ];
  };
}
