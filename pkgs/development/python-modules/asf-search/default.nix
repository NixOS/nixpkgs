{ lib, buildPythonPackage, fetchFromGitHub, pytz, shapely, importlib-metadata, requests, python-dateutil }:

buildPythonPackage rec {
  pname = "asf_search";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "asfadmin";
    repo = "Discovery-asf_search";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-9fJp4P2cD11ppU80Av/aJOcqpaBwuYgdWWBTMo/HCeo=";
  };

  propagatedBuildInputs = [ pytz shapely importlib-metadata requests python-dateutil ];

  doCheck = false;

  pythonImportsCheck = [ "asf_search" ];

  meta = with lib; {
    description = "Python wrapper for the ASF SearchAPI";
    homepage = "https://github.com/asfadmin/Discovery-asf_search";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bzizou ];
  };
}
