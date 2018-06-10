{ lib, buildPythonPackage, fetchPypi, gitdb2, mock, nose, ddt }:

buildPythonPackage rec {
  version = "2.1.9";
  pname = "GitPython";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a9in1jfv9ssxhckl6sasw45bhm762y2r5ikgb2pk2g8yqdc6z64";
  };

  checkInputs = [ mock nose ddt ];
  propagatedBuildInputs = [ gitdb2 ];

  # Tests require a git repo
  doCheck = false;

  meta = {
    description = "Python Git Library";
    maintainers = [ ];
    homepage = https://github.com/gitpython-developers/GitPython;
    license = lib.licenses.bsd3;
  };
}
