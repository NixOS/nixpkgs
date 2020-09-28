{ lib, buildPythonPackage, fetchPypi, isPy27, setuptools_scm, click }:

buildPythonPackage rec {
  pname = "git-filter-repo";
  version = "2.28.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zgvbyvj3i1k9dkrzhw8r9jrylyb0454ysac8209lj46hcmzfdcv";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    click
  ];

  meta = with lib; {
    description = "Quickly rewrite git repository history";
    license = licenses.mit;
    homepage = "https://github.com/newren/git-filter-repo";
    maintainers = with maintainers; [ ajs124 ];
  };
}
