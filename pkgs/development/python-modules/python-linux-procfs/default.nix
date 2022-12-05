{ lib, buildPythonPackage, fetchgit, six }:

buildPythonPackage rec {
  pname = "python-linux-procfs";
  version = "0.6.3";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/python/${pname}/${pname}.git";
    rev = "v${version}";
    sha256 = "sha256-PPgMlL9oj4HYUsr444ZrGo1LSZBl9hL5SE98IASUpbc=";
  };

  propagatedBuildInputs = [ six ];

  # contains no tests
  doCheck = false;
  pythonImportsCheck = [ "procfs" ];

  meta = with lib; {
    description = "Python classes to extract information from the Linux kernel /proc files";
    homepage = "https://git.kernel.org/pub/scm/libs/python/python-linux-procfs/python-linux-procfs.git/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ elohmeier ];
  };
}
