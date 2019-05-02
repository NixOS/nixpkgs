{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, click
}:

buildPythonPackage rec {
  pname = "maildir-deduplicate";
  version = "2.1.0";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "263c7f2c85dafe06eaa15e8d7ab83817204f70a5f08cc25a607f3f01ed130b42";
  };

  propagatedBuildInputs = [ click ];

  meta = with stdenv.lib; {
    description = "Command-line tool to deduplicate mails from a set of maildir folders";
    homepage = "https://github.com/kdeldycke/maildir-deduplicate";
    license = licenses.gpl2;
  };

}
