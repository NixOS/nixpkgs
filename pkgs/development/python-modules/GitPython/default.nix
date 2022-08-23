{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, git
, gitdb
, ddt
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "gitpython";
  version = "3.1.27";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gitpython-developers";
    repo = "GitPython";
    rev = version;
    sha256 = "sha256-RA+6JFXHUQoXGErV8+aYuJPsfXzNSZK3kTm6eMbQIss=";
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
