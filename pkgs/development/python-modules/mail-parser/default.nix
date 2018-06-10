{ lib, buildPythonPackage, python, pythonOlder, glibcLocales, fetchFromGitHub, ipaddress, six, simplejson }:

buildPythonPackage rec {
  pname = "mail-parser";
  version = "3.3.1";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "SpamScope";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b1v61zwgdx2xjzds3hp6bv53yq424hhlrhf445n4faj1l0c4lkg";
  };

  LC_ALL = "en_US.utf-8";

  # ipaddress is part of the standard library of Python 3.3+
  prePatch = lib.optionalString (!pythonOlder "3.3") ''
    substituteInPlace requirements.txt \
      --replace "ipaddress" ""
  '';

  nativeBuildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ simplejson six ] ++ lib.optional (pythonOlder "3.3") ipaddress;

  # Taken from .travis.yml
  checkPhase = ''
    ${python.interpreter} tests/test_main.py
    ${python.interpreter} -m mailparser -v
    ${python.interpreter} -m mailparser -h
    ${python.interpreter} -m mailparser -f tests/mails/mail_malformed_3 -j
    cat tests/mails/mail_malformed_3 | ${python.interpreter} -m mailparser -k -j
  '';

  meta = with lib; {
    description = "A mail parser for python 2 and 3";
    homepage = https://github.com/SpamScope/mail-parser;
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
  };
}
