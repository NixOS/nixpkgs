{ buildPythonPackage, fetchPypi, lib, requests, pytest, pytestcov, mock }:

buildPythonPackage rec {
  pname = "google-i18n-address";
  version = "2.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f1j1lp9bmllkzhciw0lxi7ipm8w461n0p97mz9714br0cs9glm1";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest pytestcov mock ];

  meta = with lib; {
    description = "Google's i18n address data packaged for Python";
    homepage = https://pypi.org/project/google-i18n-address/;
    maintainers = with maintainers; [ ma27 ];
    license = licenses.bsd3;
  };
}
