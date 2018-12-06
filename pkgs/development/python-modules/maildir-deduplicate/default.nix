{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, click
}:

buildPythonPackage rec {
  pname = "maildir-deduplicate";
  version = "1.0.2";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xy5z756alrjgpl9qx2gdx898rw1mryrqkwmipbh39mgrvkl3fz9";
  };

  propagatedBuildInputs = [ click ];

  meta = with stdenv.lib; {
    description = "Command-line tool to deduplicate mails from a set of maildir folders";
    homepage = "https://github.com/kdeldycke/maildir-deduplicate";
    license = licenses.gpl2;
  };

}
