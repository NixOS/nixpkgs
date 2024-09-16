{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-musicpd";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname;
    inherit version;
    hash = "sha256-/FdM0UolVqhJNpS60Q/nra1hSHKL/LiSMX7/Hcipwco=";
  };

  pyproject = true;

  build-system = [ setuptools ];

  doCheck = true;

  meta = with lib; {
    description = "MPD (Music Player Daemon) client library written in pure Python";
    homepage = "https://gitlab.com/kaliko/python-musicpd";
    license = licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
}
