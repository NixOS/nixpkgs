{
  lib,
  bitvector-for-humans,
  buildPythonPackage,
  busylight-core,
  fastapi,
  fetchFromGitHub,
  hatchling,
  hidapi,
  httpx,
  loguru,
  pyserial,
  pytest-mock,
  pytestCheckHook,
  typer,
  udevCheckHook,
  uvicorn,
  webcolors,
}:

buildPythonPackage rec {
  pname = "busylight-for-humans";
<<<<<<< HEAD
  version = "0.45.3";
=======
  version = "0.45.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "busylight";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-EP+2jWOrXQE8sZQYclMMbpfr+FmPHIbZ35NNbfCTnUk=";
=======
    hash = "sha256-G+l+jkHZzz3tX1CcC7Cq1iCFZPbeQ6CI4xCMkTWA5EE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  dependencies = [
    bitvector-for-humans
    busylight-core
    hidapi
    loguru
    pyserial
    typer
    webcolors
  ];

  optional-dependencies = {
    webapi = [
      fastapi
      uvicorn
    ];
  };

  nativeCheckInputs = [
    httpx
    pytestCheckHook
    pytest-mock
    udevCheckHook
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  disabledTestPaths = [ "tests/test_pydantic_models.py" ];

  pythonImportsCheck = [ "busylight" ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    $out/bin/busylight udev-rules -o $out/lib/udev/rules.d/99-busylight.rules
  '';

<<<<<<< HEAD
  meta = {
    description = "Control USB connected presence lights from multiple vendors via the command-line or web API";
    homepage = "https://github.com/JnyJny/busylight";
    changelog = "https://github.com/JnyJny/busylight/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.helsinki-systems ];
=======
  meta = with lib; {
    description = "Control USB connected presence lights from multiple vendors via the command-line or web API";
    homepage = "https://github.com/JnyJny/busylight";
    changelog = "https://github.com/JnyJny/busylight/releases/tag/${src.tag}";
    license = licenses.asl20;
    teams = [ teams.helsinki-systems ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "busylight";
  };
}
