{  buildPythonPackage, python, glibcLocales, fetchPypi, sphinx }:

buildPythonPackage rec {
  pname = "ModernGL";
  version = "4.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "290ae98a8f5d3ff7b32418d5f8c25e3800abc7985327053e15aeeb5b88a4d56d";
  };

  #LC_ALL = "en_US.utf-8";

  # ipaddress is part of the standard library of Python 3.3+
  #prePatch = lib.optionalString (!pythonOlder "3.3") ''
  #  substituteInPlace requirements.txt \
  #    --replace "ipaddress" ""
  #'';

  #nativeBuildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ sphinx ];

  # Taken from .travis.yml
 # checkPhase = ''
 #   ${python.interpreter} tests/test_main.py
 #   ${python.interpreter} -m mailparser -v
 #   ${python.interpreter} -m mailparser -h
 #   ${python.interpreter} -m mailparser -f tests/mails/mail_malformed_3 -j
 #   cat tests/mails/mail_malformed_3 | ${python.interpreter} -m mailparser -k -j
 # '';

}
