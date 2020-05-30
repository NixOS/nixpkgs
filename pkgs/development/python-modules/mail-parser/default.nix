{ lib, buildPythonPackage, python, pythonOlder, glibcLocales, fetchFromGitHub, ipaddress, six, simplejson }:

buildPythonPackage rec {
  pname = "mail-parser";
  version = "3.12.0";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "SpamScope";
    repo = pname;
    rev = "v${version}";
    sha256 = "0p851jlly6bzcs70kd1lcjwmg4scwh1icymfc0f2y6rkh4kfsdhk";
  };

  LC_ALL = "en_US.utf-8";

  # remove version bounds
  prePatch = ''
    sed -i -e 's/==.*//g' requirements.txt
  ''
  # ipaddress is part of the standard library of Python 3.3+
  + lib.optionalString (!pythonOlder "3.3") ''
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
    homepage = "https://github.com/SpamScope/mail-parser";
    license = licenses.asl20;
    maintainers = with maintainers; [ psyanticy ];
  };
}
