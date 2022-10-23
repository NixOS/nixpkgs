{ lib, buildPythonPackage, fetchPypi, isPy3k, six, httplib2, requests }:

buildPythonPackage rec {
  pname = "mailmanclient";
  version = "3.3.4";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0y31HXjvU/bwy0s0PcDOlrX1RdyTTnk41ceD4A0R4p4=";
  };

  propagatedBuildInputs = [ six httplib2 requests ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/mailman/";
    description = "REST client for driving Mailman 3";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin qyliss ];
  };
}
