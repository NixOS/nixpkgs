{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, xmltodict
}:

buildPythonPackage rec {
  pname = "meteoalertapi";
  version = "0.2.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rolfberkenbosch";
    repo = "meteoalert-api";
    rev = "v${version}";
    sha256 = "sha256-EdHqWEkE/uUtz/xjV4k4NvNvtPPU4sJjHGwUM7J+HWs=";
  };

  propagatedBuildInputs = [
    requests
    xmltodict
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "meteoalertapi" ];

  meta = with lib; {
    description = "Python wrapper for MeteoAlarm.org";
    homepage = "https://github.com/rolfberkenbosch/meteoalert-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
