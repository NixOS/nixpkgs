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
  version = "3.15.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "SpamScope";
    repo = pname;
    rev = "v${version}";
    sha256 = "0da2qr4p8jnjw6jdhbagm6slfcjnjyyjkszwfcfqvcywh1zm1sdw";
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
