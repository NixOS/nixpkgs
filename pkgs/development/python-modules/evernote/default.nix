{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, oauth2
}:

buildPythonPackage rec {
  pname = "evernote";
  version = "1.25.0";
  disabled = ! isPy27; #some dependencies do not work with py3

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lwlg6fpi3530245jzham1400a5b855bm4sbdyck229h9kg1v02d";
  };

   propagatedBuildInputs = [ oauth2 ];

   meta = with stdenv.lib; {
    description = "Evernote SDK for Python";
    homepage = http://dev.evernote.com;
    license = licenses.asl20;
    maintainers = with maintainers; [ hbunke ];
   };

}
