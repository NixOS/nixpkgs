{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "python-juicenet";
  version = "1.1.0";
  format = "setuptools";

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

  meta = {
    description = "Read and control Juicenet/Juicepoint/Juicebox based EVSE devices";
    homepage = "https://github.com/jesserockz/python-juicenet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
