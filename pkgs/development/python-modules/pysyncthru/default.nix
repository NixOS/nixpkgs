{ lib
, isPy27
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, demjson
, python
}:

buildPythonPackage rec {
  pname = "pysyncthru";
  version = "0.7.7";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = "pysyncthru";
    rev = "release-${version}";
    sha256 = "1449lbg9dx13p03v6fl2ap0xk5i5wrmy6amx1pl0rgz712p5jmq7";
  };

  propagatedBuildInputs = [
    aiohttp
    demjson
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [ "pysyncthru" ];

  meta = with lib; {
    description = "Automated JSON API based communication with Samsung SyncThru Web Service";
    homepage = "https://github.com/nielstron/pysyncthru";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
