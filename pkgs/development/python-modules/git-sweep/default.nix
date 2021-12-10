{ lib
, buildPythonPackage
, fetchFromGitHub
, GitPython
}:

buildPythonPackage rec {
  pname = "git-sweep";
  version = "0.1.1";

  src = fetchFromGitHub {
     owner = "arc90";
     repo = "git-sweep";
     rev = "0.1.1";
     sha256 = "1237q8c5jk09gci5x26zc99xhw7irypwfp0snz7z4dfa6l76a0pb";
  };

  propagatedBuildInputs = [ GitPython ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "gitsweep" ];

  meta = with lib; {
    description = "A command-line tool that helps you clean up Git branches";
    homepage = "https://github.com/arc90/git-sweep";
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
  };

}
