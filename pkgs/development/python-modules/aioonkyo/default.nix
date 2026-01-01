{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioonkyo";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "arturpragacz";
    repo = "aioonkyo";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-hLtyQWChWBddefDUT/+7e/w6i/DPEm/zw+EqOPgGsUI=";
=======
    hash = "sha256-xGSvwfCwWfWHZTl4+Uf+vgI5JkjeO5affbURqpLsCuk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioonkyo" ];

  meta = {
    description = "Library for controlling Onkyo AV receivers";
    homepage = "https://github.com/arturpragacz/aioonkyo";
    changelog = "https://github.com/arturpragacz/aioonkyo/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
