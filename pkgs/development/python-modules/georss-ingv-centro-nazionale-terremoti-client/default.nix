{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-ingv-centro-nazionale-terremoti-client";
  version = "0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-ingv-centro-nazionale-terremoti-client";
    rev = "v${version}";
    sha256 = "sha256-zqjo70NzpUt5zNEar0P1sl/gMb+ZcS+7GX7QGuFjMYY=";
  };

  propagatedBuildInputs = [
    georss-client
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "georss_ingv_centro_nazionale_terremoti_client"
  ];

  meta = with lib; {
    description = "Python library for accessing the INGV Centro Nazionale Terremoti GeoRSS feed";
    homepage = "https://github.com/exxamalte/python-georss-ingv-centro-nazionale-terremoti-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
