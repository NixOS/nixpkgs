{
  lib,
  buildPythonPackage,
  fetchPypi,
  sabnzbd,
}:
buildPythonPackage rec {
  pname = "sabctools";
  version = "8.0.0"; # needs to match version sabnzbd expects, e.g. https://github.com/sabnzbd/sabnzbd/blob/4.0.x/requirements.txt#L3
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hrRpEVhmnm4ABSqN/F3MllCgoJCg1PdM+oVrQR+uZbk=";
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
