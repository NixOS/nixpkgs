{ lib
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  pname = "isosurfaces";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa1b44e5e59d2f429add49289ab89e36f8dcda49b7badd99e0beea273be331f4";
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
    maintainers = with maintainers; [ friedelino ];
  };
}
