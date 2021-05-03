{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, substituteAll
, git
, gitdb
, ddt
}:

buildPythonPackage rec {
  pname = "GitPython";
  version = "3.1.14";
  disabled = isPy27; # no longer supported

  src = fetchPypi {
    inherit pname version;
    sha256 = "be27633e7509e58391f10207cd32b2a6cf5b908f92d9cd30da2e514e1137af61";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-git-path.patch;
      inherit git;
    })
  ];

  propagatedBuildInputs = [ gitdb ddt ];

  # Tests require a git repo
  doCheck = false;
  pythonImportsCheck = [ "git" ];

  meta = with lib; {
    description = "Python Git Library";
    homepage = "https://github.com/gitpython-developers/GitPython";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
