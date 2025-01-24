{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "1.3.2";
  format = "setuptools";
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
    maintainers = [ ];

    # Cython generated code is vendored directly and no longer compatible with
    # newer versions of the CPython C API.
    #
    # Upstream explicitly removed the Cython source files from the source
    # distribution, making it impossible for us to force-compile them:
    # https://github.com/joe-jordan/pyvoro/commit/922bba6db32d44c2e1825228627a25aa891f9bc1
    #
    # No upstream activity since 2014.
    broken = true;
  };
}
