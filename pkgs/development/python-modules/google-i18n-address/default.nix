{ buildPythonPackage, fetchPypi, lib, requests, pytest, pytestcov, mock }:

buildPythonPackage rec {
  pname = "google-i18n-address";
  version = "2.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kkg3x92m40z0mw712z9apnrw08qsx0f9lj7lfgddkdbx4vd8v3w";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest pytestcov mock ];

  meta = with lib; {
    description = "Google's i18n address data packaged for Python";
    homepage = https://pypi.org/project/google-i18n-address/;
    maintainers = with maintainers; [ ];
    license = licenses.bsd3;
  };
}
