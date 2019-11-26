{ lib, buildPythonPackage, fetchPypi, isPy27, substituteAll, git, gitdb2, mock, nose, ddt }:

buildPythonPackage rec {
  version = "3.0.5";
  pname = "GitPython";
  disabled = isPy27; # no longer supported

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c2398ffc3dcb3c40b27324b316f08a4f93ad646d5a6328cafbb871aa79f5e42";
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
