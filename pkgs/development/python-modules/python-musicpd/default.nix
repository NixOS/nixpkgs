{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-musicpd";
  version = "0.9.2";
  pyproject = true;

  src = fetchPypi {
    pname = "python_musicpd";
    inherit version;
    hash = "sha256-RFYIVDTy492sfp68sjO0MFKcHI9Gxt25Ixdu8iiOlTo=";
  };

  build-system = [ setuptools ];

  meta = with lib; {
    description = "MPD (Music Player Daemon) client library written in pure Python";
    homepage = "https://gitlab.com/kaliko/python-musicpd";
    license = licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
}
