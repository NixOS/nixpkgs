{ lib, buildPythonPackage, fetchPypi, isPy27, substituteAll, git, gitdb, mock, nose, ddt }:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "GitPython";
  disabled = isPy27; # no longer supported

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jzllsy9lwc9yibccgv7h9naxisazx2n3zmpy21c8n5xhysw69p4";
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
    homepage = https://github.com/gitpython-developers/GitPython;
    license = lib.licenses.bsd3;
  };
}
