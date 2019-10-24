{ lib, buildPythonPackage, fetchPypi, isPy27, substituteAll, git, gitdb2, mock, nose, ddt }:

buildPythonPackage rec {
  version = "3.0.4";
  pname = "GitPython";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3237caca1139d0a7aa072f6735f5fd2520de52195e0fa1d8b83a9b212a2498b2";
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
