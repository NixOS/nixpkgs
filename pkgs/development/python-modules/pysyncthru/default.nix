{ lib
, isPy27
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, demjson3
, python
}:

buildPythonPackage rec {
  pname = "pysyncthru";
  version = "0.7.10";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = "pysyncthru";
    rev = "release-${version}";
    sha256 = "1c29w2ldrnq0vxr9cfa2pjhwdvrpw393c84khgg2y56jrkbidq53";
  };

  propagatedBuildInputs = [
    aiohttp
    demjson3
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
