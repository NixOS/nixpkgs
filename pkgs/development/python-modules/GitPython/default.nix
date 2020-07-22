{ lib, buildPythonPackage, fetchPypi, isPy27, substituteAll, git, gitdb, mock, nose, ddt }:

buildPythonPackage rec {
  version = "3.1.3";
  pname = "GitPython";
  disabled = isPy27; # no longer supported

  src = fetchPypi {
    inherit pname version;
    sha256 = "e107af4d873daed64648b4f4beb89f89f0cfbe3ef558fc7821ed2331c2f8da1a";
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
