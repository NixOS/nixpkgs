{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  lxml,
  fastapi,
  httpx,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "inscriptis";
  version = "2.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "weblyzard";
    repo = "inscriptis";
    tag = version;
    hash = "sha256-+qLHdQ4i/PYSUCZLYV3BguXjacjs7aB3MP0rJegv+dI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    lxml
    requests
  ];

  nativeCheckInputs = [
    fastapi
    httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "inscriptis" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "HTML to text converter";
    mainProgram = "inscript.py";
    homepage = "https://github.com/weblyzard/inscriptis";
    changelog = "https://github.com/weblyzard/inscriptis/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = lib.licenses.asl20;
=======
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
