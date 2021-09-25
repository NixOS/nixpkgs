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
  version = "0.7.8";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = "pysyncthru";
    rev = "release-${version}";
    sha256 = "17k9dhnya4304gqmkyvvf94jvikmnkf2lqairl3rfrl7w68jm3vp";
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
