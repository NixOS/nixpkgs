{ lib, buildPythonPackage, fetchPypi, isPy3k, six, httplib2, requests }:

buildPythonPackage rec {
  pname = "mailmanclient";
  version = "3.3.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4082ac0c66d7f7bee15751fe2564098b971177c0013e66d0c8ceee1ebdcb5592";
  };

  propagatedBuildInputs = [ six httplib2 requests ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/mailman/";
    description = "REST client for driving Mailman 3";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peti globin qyliss ];
  };
}
