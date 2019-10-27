{ stdenv, buildPythonPackage, fetchPypi, six, httplib2 }:

buildPythonPackage rec {
  pname = "mailmanclient";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8736cbe152ae1bd58b46ccfbcafb6a1e301513530772e7fda89f91d1e5c1ae9";
  };

  propagatedBuildInputs = [ six httplib2 ];

  meta = with stdenv.lib; {
    homepage = "http://www.gnu.org/software/mailman/";
    description = "REST client for driving Mailman 3";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peti globin ];
  };
}
