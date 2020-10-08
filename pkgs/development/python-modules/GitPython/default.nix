{ lib, buildPythonPackage, fetchPypi, isPy27, substituteAll, git, gitdb, mock, nose, ddt }:

buildPythonPackage rec {
  version = "3.1.7";
  pname = "GitPython";
  disabled = isPy27; # no longer supported

  src = fetchPypi {
    inherit pname version;
    sha256 = "2db287d71a284e22e5c2846042d0602465c7434d910406990d5b74df4afb0858";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-git-path.patch;
      inherit git;
    })
  ];

  checkInputs = [ nose ] ++ lib.optional isPy27 mock;
  propagatedBuildInputs = [ gitdb ddt ];

  # Tests require a git repo
  doCheck = false;

  meta = {
    description = "Python Git Library";
    maintainers = [ ];
    homepage = "https://github.com/gitpython-developers/GitPython";
    license = lib.licenses.bsd3;
  };
}
