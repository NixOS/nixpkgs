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
  version = "1.15.0";

  disabled = pythonOlder "3.6"; # requires python version >=3.6

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb-client-python";
    rev = "v${version}";
    sha256 = "1b2xh78v965rgafyj7cdbjm2p96d74f7ifsqllc7242n9wv3k53q";
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
