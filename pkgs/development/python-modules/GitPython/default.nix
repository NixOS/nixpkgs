{ lib, buildPythonPackage, fetchPypi, git, gitdb2, mock, nose, ddt }:

buildPythonPackage rec {
  version = "2.1.11";
  pname = "GitPython";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8237dc5bfd6f1366abeee5624111b9d6879393d84745a507de0fda86043b65a8";
  };

  checkInputs = [ mock nose ddt ];
  propagatedBuildInputs = [ gitdb2 ];

  postPatch = ''
    sed -i "s|^refresh()$|refresh(path='${git}/bin/git')|" git/__init__.py
  '';

  # Tests require a git repo
  doCheck = false;

  meta = {
    description = "Python Git Library";
    maintainers = [ ];
    homepage = https://github.com/gitpython-developers/GitPython;
    license = lib.licenses.bsd3;
  };
}
