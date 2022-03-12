{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
}:

buildPythonPackage rec {
  pname = "python-juicenet";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jesserockz";
    repo = "python-juicenet";
    rev = "v${version}";
    sha256 = "sha256-5RKnVwOfEHzFZCiC8OUpS8exKrENK+I3Ok45HlKEvtU=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyjuicenet" ];

  meta = with lib; {
    description = "Read and control Juicenet/Juicepoint/Juicebox based EVSE devices";
    homepage = "https://github.com/jesserockz/python-juicenet";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
