{ lib, buildPythonPackage, fetchPypi, isPy27, substituteAll, git, gitdb2, mock, nose, ddt }:

buildPythonPackage rec {
  version = "2.1.11";
  pname = "GitPython";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8237dc5bfd6f1366abeee5624111b9d6879393d84745a507de0fda86043b65a8";
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
