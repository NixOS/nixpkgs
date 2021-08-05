{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, substituteAll
, git
, gitdb
, ddt
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "GitPython";
  version = "3.1.19";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lqf5plm02aw9zl73kffk7aa4mp4girm3f2yfk27nmmmjsdh7x0q";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-git-path.patch;
      inherit git;
    })
  ];

  propagatedBuildInputs = [
    gitdb
    ddt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

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
