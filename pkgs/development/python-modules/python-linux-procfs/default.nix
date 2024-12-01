{
  lib,
  buildPythonPackage,
  fetchurl,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "python-linux-procfs";
  version = "0.7.3";
  pyproject = true;

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/libs/python/python-linux-procfs/python-linux-procfs.git/snapshot/python-linux-procfs-v${version}.tar.gz";
    hash = "sha256-6js8+PBqMwNYSe74zqZP8CZ5nt1ByjCWnex+wBY/LZU=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  # contains no tests
  doCheck = false;
  pythonImportsCheck = [ "procfs" ];

  meta = with lib; {
    description = "Python classes to extract information from the Linux kernel /proc files";
    mainProgram = "pflags";
    homepage = "https://git.kernel.org/pub/scm/libs/python/python-linux-procfs/python-linux-procfs.git/";
    license = licenses.gpl2Plus;
  };
}
