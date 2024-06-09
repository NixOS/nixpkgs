{
  lib,
  buildPythonPackage,
  fetchzip,
  six,
}:

buildPythonPackage rec {
  pname = "python-linux-procfs";
  version = "0.6.3";
  format = "setuptools";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/libs/python/python-linux-procfs/python-linux-procfs.git/snapshot/python-linux-procfs-v${version}.tar.gz";
    hash = "sha256-iaKL7CWJbIvvcUCah7bKdwKZoZJehbQpZ7n0liO8N64=";
  };

  propagatedBuildInputs = [ six ];

  # contains no tests
  doCheck = false;
  pythonImportsCheck = [ "procfs" ];

  meta = with lib; {
    description = "Python classes to extract information from the Linux kernel /proc files";
    mainProgram = "pflags";
    homepage = "https://git.kernel.org/pub/scm/libs/python/python-linux-procfs/python-linux-procfs.git/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ elohmeier ];
  };
}
