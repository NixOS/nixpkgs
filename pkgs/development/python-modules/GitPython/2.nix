{ lib, buildPythonPackage, fetchPypi, isPy3k, substituteAll, git, gitdb2, mock, nose, ddt }:

buildPythonPackage rec {
  version = "2.1.15";
  pname = "GitPython";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ip1j6jalj6adz0f8r5axdjwnmzqmadypm6v8v8jyyx9hbc3i343";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-git-path.patch;
      inherit git;
    })
  ];

  checkInputs = [ nose ] ++ lib.optional isPy3k mock;
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
