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
  version = "0.7.5";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "nielstron";
    repo = "pysyncthru";
    rev = "release-${version}";
    sha256 = "122zxwqwx03vaxbhmp3cjibjnkirayz0w68gvslsdr7n9nqv3pgz";
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
