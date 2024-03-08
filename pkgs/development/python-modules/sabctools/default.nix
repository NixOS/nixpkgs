{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sabnzbd,
}:
buildPythonPackage rec {
  pname = "sabctools";
  version = "8.1.0"; # needs to match version sabnzbd expects, e.g. https://github.com/sabnzbd/sabnzbd/blob/4.0.x/requirements.txt#L3
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PYfbmR9wT3SHT+oFyQF2F13g7FgdvY/l9p0D65c/+RU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = ["sabctools"];

  passthru.tests = {inherit sabnzbd;};

  meta = with lib; {
    description = "C implementations of functions for use within SABnzbd";
    homepage = "https://github.com/sabnzbd/sabctools";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [adamcstephens];
  };
}
