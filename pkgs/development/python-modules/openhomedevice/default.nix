{ lib
, async-upnp-client
, buildPythonPackage
, fetchFromGitHub
, lxml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "openhomedevice";
  version = "2.0.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bazwilliams";
    repo = pname;
    rev = version;
    sha256 = "sha256-BQgwXg15+xEGfPm0HJWpKXbNuCgc0VcAD5AuVSDXd8g=";
  };

  propagatedBuildInputs = [
    async-upnp-client
    lxml
  ];

  # Tests are currently outdated
  # https://github.com/bazwilliams/openhomedevice/issues/20
  doCheck = false;
  pythonImportsCheck = [ "openhomedevice" ];

  meta = with lib; {
    description = "Python module to access Linn Ds and Openhome devices";
    homepage = "https://github.com/bazwilliams/openhomedevice";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
