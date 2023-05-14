{ lib, buildPythonPackage, fetchFromGitHub, udatetime, pytz, pendulum, nose
, delorean, coveralls, arrow
}:

buildPythonPackage rec {
  pname = "pycron";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "kipe";
    repo = pname;
    rev = version;
    sha256 = "12hkqrdfg3jbqkmck8i00ssyaw1c4hhvdhjxkmh2gm9pd99z5bpv";
  };

  nativeCheckInputs = [ arrow coveralls delorean nose pendulum pytz udatetime ];

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [ "pycron" ];

  meta = with lib; {
    description = "Simple cron-like parser for Python, which determines if current datetime matches conditions";
    license = licenses.mit;
    homepage = "https://github.com/kipe/pycron";
    maintainers = with maintainers; [ globin ];
  };
}
