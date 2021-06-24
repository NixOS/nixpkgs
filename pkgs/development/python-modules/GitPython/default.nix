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
  version = "3.1.13";
  disabled = isPy27; # no longer supported

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hiGn53fidqXsg4tZKAulJy3RRKGBacNskD2LOLmfdQo=";
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
