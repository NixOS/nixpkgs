{ lib, buildPythonPackage, fetchFromGitHub, python, robotframework }:

buildPythonPackage rec {
<<<<<<< HEAD
  version = "3.0.1";
=======
  version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "robotstatuschecker";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "statuschecker";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-yW6353gDwo/IzoWOB8oelaS6IUbvTtwwDT05yD7w6UA=";
=======
    hash = "sha256-7xHPqlR7IFZp3Z120mg25ZSg9eI878kE8RF1y3F5O70=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ robotframework ];

  checkPhase = ''
    ${python.interpreter} test/run.py
  '';

  meta = with lib; {
    description = "A tool for checking that Robot Framework test cases have expected statuses and log messages";
    homepage = "https://github.com/robotframework/statuschecker";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
