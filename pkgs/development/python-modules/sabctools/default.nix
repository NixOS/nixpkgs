{
  lib,
  buildPythonPackage,
  fetchPypi,
  sabnzbd,
}:
buildPythonPackage rec {
  pname = "sabctools";
  version = "7.1.2"; # needs to match version sabnzbd expects, e.g. https://github.com/sabnzbd/sabnzbd/blob/4.0.x/requirements.txt#L3
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wDgFXuxclmqMlRXyr9qpruJJcOXfOiOWTZXX53uYEB8=";
  };

  pythonImportsCheck = ["sabctools"];

  passthru.tests = {inherit sabnzbd;};

  meta = with lib; {
    description = "C implementations of functions for use within SABnzbd";
    homepage = "https://github.com/sabnzbd/sabctools";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [adamcstephens];
  };
}
