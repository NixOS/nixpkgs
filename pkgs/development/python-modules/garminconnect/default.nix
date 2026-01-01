{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  garth,
  pdm-backend,
  requests,
  withings-sync,
}:

buildPythonPackage rec {
  pname = "garminconnect";
<<<<<<< HEAD
  version = "0.2.36";
=======
  version = "0.2.34";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-jbCp4R3Pg9idtIw5blEprf1wdewceA8YB62yht58jLI=";
=======
    hash = "sha256-gcqkSWyPSwkzykKSXhTPq363fi89TyP2DPQchSmGg/k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = [
    "garth"
    "withings-sync"
  ];

  build-system = [ pdm-backend ];

  dependencies = [
    garth
    requests
    withings-sync
  ];

  # Tests require a token
  doCheck = false;

  pythonImportsCheck = [ "garminconnect" ];

<<<<<<< HEAD
  meta = {
    description = "Garmin Connect Python API wrapper";
    homepage = "https://github.com/cyberjunky/python-garminconnect";
    changelog = "https://github.com/cyberjunky/python-garminconnect/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Garmin Connect Python API wrapper";
    homepage = "https://github.com/cyberjunky/python-garminconnect";
    changelog = "https://github.com/cyberjunky/python-garminconnect/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
