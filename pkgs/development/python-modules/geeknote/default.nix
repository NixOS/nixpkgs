{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, thrift
, beautifulsoup4
, markdown2
, sqlalchemy
, html2text
, evernote
}:

buildPythonPackage rec {
  version = "2015-05-11";
  pname = "geeknote";
  disabled = ! isPy27;

  src = fetchFromGitHub {
    owner = "VitaliyRodnenko";
    repo = "geeknote";
    rev = "8489a87d044e164edb321ba9acca8d4631de3dca";
    sha256 = "0l16v4xnyqnsf84b1pma0jmdyxvmfwcv3sm8slrv3zv7zpmcm3lf";
  };

  /* build with tests fails with "Can not create application dirictory :
   /homeless-shelter/.geeknotebuilder". */
  doCheck = false;

  propagatedBuildInputs = [ thrift beautifulsoup4 markdown2 sqlalchemy html2text evernote ];

  meta = with stdenv.lib; {
    description = "Work with Evernote from command line";
    homepage = http://www.geeknote.me;
    license = licenses.gpl1;
    maintainers = with maintainers; [ hbunke ];
  };

}
