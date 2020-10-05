{ lib, buildPythonPackage, fetchPypi, isPy27, substituteAll, git, gitdb, mock, nose, ddt }:

buildPythonPackage rec {
  version = "3.1.9";
  pname = "GitPython";
  disabled = isPy27; # no longer supported

  src = fetchPypi {
    inherit pname version;
    sha256 = "a03f728b49ce9597a6655793207c6ab0da55519368ff5961e4a74ae475b9fa8e";
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
