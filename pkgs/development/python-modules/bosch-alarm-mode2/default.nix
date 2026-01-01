{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
}:

buildPythonPackage rec {
  pname = "bosch-alarm-mode2";
<<<<<<< HEAD
  version = "0.4.10";
=======
  version = "0.4.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mag1024";
    repo = "bosch-alarm-mode2";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-XpLMPFi3e6iTtKGfVXN4VbnPyNLVjSFrodyFK+zelF4=";
=======
    hash = "sha256-UafhNafZ1qb/OYXSvMGaIzDxVGf4jVmdGyv4xrcU43g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [ "bosch_alarm_mode2" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Async Python library for interacting with Bosch Alarm Panels supporting the 'Mode 2' API";
    homepage = "https://github.com/mag1024/bosch-alarm-mode2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
