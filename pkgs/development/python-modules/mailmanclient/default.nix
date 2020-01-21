{ stdenv, buildPythonPackage, fetchPypi, isPy3k, six, httplib2, requests }:

buildPythonPackage rec {
  pname = "mailmanclient";
  version = "3.3.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8736cbe152ae1bd58b46ccfbcafb6a1e301513530772e7fda89f91d1e5c1ae9";
  };

  propagatedBuildInputs = [ six httplib2 requests ];

  # no tests with Pypi tar ball, checkPhase removes setup.py which invalidates import check
  doCheck = false;
  pythonImportsCheck = [ "mailmanclient" ];

  meta = with stdenv.lib; {
    homepage = "http://www.gnu.org/software/mailman/";
    description = "REST client for driving Mailman 3";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peti globin ];
  };
}
