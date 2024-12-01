{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-musicpd";
  version = "0.9.1";
  pyproject = true;

  src = fetchPypi {
    pname = "python_musicpd";
    inherit version;
    hash = "sha256-zKjazEIxja6/tPWFXQhEYlLd1Jl8py9wirKsoDXeGu4=";
  };

  build-system = [ setuptools ];

  meta = with lib; {
    description = "MPD (Music Player Daemon) client library written in pure Python";
    homepage = "https://gitlab.com/kaliko/python-musicpd";
    license = licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
}
