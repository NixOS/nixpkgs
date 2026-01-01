{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pymvglive";
  version = "1.1.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyMVGLive";
    inherit version;
    sha256 = "0sh4xm74im9qxzpbrlc5h1vnpgvpybnpvdcav1iws0b561zdr08c";
  };

  propagatedBuildInputs = [ requests ];

<<<<<<< HEAD
  meta = {
    description = "Get live-data from mvg-live.de";
    homepage = "https://github.com/pc-coholic/PyMVGLive";
    license = lib.licenses.free;
=======
  meta = with lib; {
    description = "Get live-data from mvg-live.de";
    homepage = "https://github.com/pc-coholic/PyMVGLive";
    license = licenses.free;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
