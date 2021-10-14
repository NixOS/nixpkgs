{ lib, buildPythonPackage, fetchPypi, isPy3k, six, httplib2, requests }:

buildPythonPackage rec {
  pname = "mailmanclient";
  version = "3.3.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "92fe624675e41f41f59de1208e0125dfaa8d062bbe6138bd7cd79e4dd0b6f85e";
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
