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
  version = "1.13.0";

  disabled = pythonOlder "3.6"; # requires python version >=3.6

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb-client-python";
    rev = "v${version}";
    sha256 = "0g7jhjnag8jx8zbjh6xlqds42alpj87a4dpqc37xqa4ir55m3c2q";
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
