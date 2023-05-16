{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.3.2";
  pname = "pyvoro";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f31c047f6e4fc5f66eb0ab43afd046ba82ce247e18071141791364c4998716fc";
  };

  # No tests in package
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/joe-jordan/pyvoro";
    description = "2D and 3D Voronoi tessellations: a python entry point for the voro++ library";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
