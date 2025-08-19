{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sabnzbd,
}:
buildPythonPackage rec {
  pname = "sabctools";
  version = "8.2.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-olZSIjfP2E1tkCG8WzEZfrBJuDEp3PZyFFE5LJODEZE=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "sabctools" ];

  passthru.tests = {
    inherit sabnzbd;
  };

  meta = with lib; {
    description = "C implementations of functions for use within SABnzbd";
    homepage = "https://github.com/sabnzbd/sabctools";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ adamcstephens ];
  };
}
