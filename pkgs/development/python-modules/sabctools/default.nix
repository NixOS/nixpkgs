{
  lib,
  buildPythonPackage,
  fetchPypi,
  sabnzbd,
}:
buildPythonPackage rec {
  pname = "sabctools";
  version = "7.0.2"; # needs to match version sabnzbd expects, e.g. https://github.com/sabnzbd/sabnzbd/blob/4.0.x/requirements.txt#L3
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AB5/McuOIDkhu7rtb3nFaqOTx3zwm92+3NEnH5HjzBo=";
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
