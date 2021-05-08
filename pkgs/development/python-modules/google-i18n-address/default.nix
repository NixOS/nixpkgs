{ buildPythonPackage, fetchPypi, pythonAtLeast, lib, requests, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "google-i18n-address";
  version = "2.4.0";
  disabled = pythonAtLeast "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8454a58f254a29988b8d1ca9ab663fd28a1f392a3d29b844d8824807db6333d7";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytestCheckHook mock ];

  meta = with lib; {
    description = "Google's i18n address data packaged for Python";
    homepage = "https://github.com/mirumee/google-i18n-address";
    maintainers = with maintainers; [ SuperSandro2000 ];
    license = licenses.bsd3;
  };
}
