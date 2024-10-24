{
  lib,
  buildPythonPackage,
  python,
  glibcLocales,
  fetchFromGitHub,
  six,
  simplejson,
}:

buildPythonPackage rec {
  pname = "mail-parser";
  version = "4.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "SpamScope";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-WpV1WJFwzAquPXimew86YpEp++dnkIiBe5E4lMBDl7w=";
  };

  LC_ALL = "en_US.utf-8";

  nativeBuildInputs = [ glibcLocales ];
  propagatedBuildInputs = [
    simplejson
    six
  ];

  # Taken from .travis.yml
  checkPhase = ''
    ${python.interpreter} tests/test_main.py
    ${python.interpreter} -m mailparser -v
    ${python.interpreter} -m mailparser -h
    ${python.interpreter} -m mailparser -f tests/mails/mail_malformed_3 -j
    cat tests/mails/mail_malformed_3 | ${python.interpreter} -m mailparser -k -j
  '';

  meta = with lib; {
    description = "Mail parser for python 2 and 3";
    mainProgram = "mailparser";
    homepage = "https://github.com/SpamScope/mail-parser";
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
  };
}
