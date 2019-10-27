{ lib, buildPythonPackage, fetchPypi, isPy27, substituteAll, git, gitdb2, mock, nose, ddt }:

buildPythonPackage rec {
  version = "2.1.14";
  pname = "GitPython";

  src = fetchPypi {
    inherit pname version;
    sha256 = "392f31eaadc19db35a54e3ab7285577fb4a86d96ecee08cf22a573f06633baab";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-git-path.patch;
      inherit git;
    })
  ];

  checkInputs = [ nose ] ++ lib.optional isPy27 mock;
  propagatedBuildInputs = [ gitdb2 ddt ];

  # Tests require a git repo
  doCheck = false;

  meta = {
    description = "Python Git Library";
    maintainers = [ ];
    homepage = https://github.com/gitpython-developers/GitPython;
    license = lib.licenses.bsd3;
  };
}
