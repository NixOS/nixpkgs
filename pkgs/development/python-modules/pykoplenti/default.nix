{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  prompt-toolkit,
  pycryptodome,
  pydantic,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pykoplenti";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stegm";
    repo = "pykoplenti";
    tag = "v${version}";
    hash = "sha256-vsqbjNj5x7X0VGbTq+CdZ9rPXVDypBkgaCI6MImloLo=";
  };

  pythonRelaxDeps = [ "pydantic" ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    pycryptodome
    pydantic
  ];

  optional-dependencies = {
    CLI = [
      click
      prompt-toolkit
    ];
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykoplenti" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python REST client API for Kostal Plenticore Inverters";
    mainProgram = "pykoplenti";
    homepage = "https://github.com/stegm/pykoplenti/";
    changelog = "https://github.com/stegm/pykoplenti/releases/tag/v${version}";
<<<<<<< HEAD
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
=======
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
