{ stdenv, buildPythonPackage, fetchPypi
, jinja2, markupsafe, pagerduty, pushbullet, python_magic, python-simple-hipchat
, pyyaml, redis, requests, six, websocket_client, nose
}:
buildPythonPackage rec {
  pname = "graphitepager";
  version = "0.2.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v3g1qcgnkpgjzh6phnv13lnk8qjrcs9sq2qg6k0dk5ik31jfk3d";
  };

  propagatedBuildInputs = [
    jinja2 markupsafe pagerduty pushbullet python_magic python-simple-hipchat
    pyyaml redis requests six websocket_client
  ];

  postPatch = ''
    substituteInPlace requirements.txt --replace "==" ">="
  '';

  checkInputs = [ nose ];
  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    description = "A simple alerting application for Graphite metrics";
    homepage = https://github.com/seatgeek/graphite-pager;
    maintainers = with maintainers; [ offline basvandijk ];
    license = licenses.bsd2;
  };
}
