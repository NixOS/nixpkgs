{ lib, buildPythonPackage, fetchFromGitHub, pytz, shapely, importlib-metadata, requests, python-dateutil }:

buildPythonPackage rec {
  pname = "asf_search";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "asfadmin";
    repo = "Discovery-${pname}";
    rev = "v${version}";
    sha256 = "1jzah2l1db1p2mv59w9qf0x3a9hk6s5rzy0jnp2smsddvyxfwcyn";
  };

  doCheck = false;

  pythonImportsCheck = [ "asf_search" ];

  propagatedBuildInputs = [ pytz shapely importlib-metadata requests python-dateutil ];

  meta = with lib; {
    description = "Python wrapper for the ASF SearchAPI";
    homepage = "https://github.com/asfadmin/Discovery-asf_search";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bzizou ];
  };
}
