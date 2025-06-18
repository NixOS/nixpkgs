{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-juicenet";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jesserockz";
    repo = "python-juicenet";
    rev = "v${version}";
    hash = "sha256-5RKnVwOfEHzFZCiC8OUpS8exKrENK+I3Ok45HlKEvtU=";
  };

  propagatedBuildInputs = [ aiohttp ];

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
