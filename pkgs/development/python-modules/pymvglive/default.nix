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
    hash = "sha256-DIHcfjBlAc1j2Iq1fe3yd79rd4CF0bzu7zjVSE7tBGo=";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "get live-data from mvg-live.de";
    homepage = "https://github.com/pc-coholic/PyMVGLive";
    license = licenses.free;
  };
}
