{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-musicpd";
  version = "0.9.3";
  pyproject = true;

  src = fetchPypi {
    pname = "python_musicpd";
    inherit version;
    hash = "sha256-STK6PFlYTKfviwN5NOFlVBlneLtq38nheuL5gX+Bbwk=";
  };

  build-system = [ setuptools ];

  meta = {
    description = "MPD (Music Player Daemon) client library written in pure Python";
    homepage = "https://gitlab.com/kaliko/python-musicpd";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
}
