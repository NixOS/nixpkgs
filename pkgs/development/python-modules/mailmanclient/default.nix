{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six, httplib2, requests }:

buildPythonPackage rec {
  pname = "mailmanclient";
  version = "3.3.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pjgzpvhdb6ql8asb20xr8d01m646zpghmcp9fmscks0n1k4di4g";
  };

  propagatedBuildInputs = [ six httplib2 requests ];

  meta = with stdenv.lib; {
    homepage = "https://www.gnu.org/software/mailman/";
    description = "REST client for driving Mailman 3";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peti globin ];
  };
}
