{ lib
, buildPythonPackage
, fetchFromGitHub
, rx
, certifi
, six
, python-dateutil
, setuptools
, urllib3
, ciso8601
, pytz
, pythonOlder
}:

buildPythonPackage rec {
  pname = "influxdb-client";
  version = "1.12.0";

  disabled = pythonOlder "3.6"; # requires python version >=3.6

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb-client-python";
    rev = "v${version}";
    sha256 = "0b4xr8nwrnikj2rnyrrcl6pym2il8iirr9f9cyg6vzfgx8l8brk9";
  };

  # makes test not reproducible
  postPatch = ''
    sed -i -e '/randomize/d' test-requirements.txt
  '';

  propagatedBuildInputs = [
    rx
    certifi
    six
    python-dateutil
    setuptools
    urllib3
    ciso8601
    pytz
  ];

  # requires influxdb server
  doCheck = false;

  meta = with lib; {
    description = "InfluxDB 2.0 Python client library";
    homepage = "https://github.com/influxdata/influxdb-client-python";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
