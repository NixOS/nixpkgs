{
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "letpot";
<<<<<<< HEAD
  version = "0.6.4";
=======
  version = "0.6.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpelgrom";
    repo = "python-letpot";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ayNgRJb+/hfxxfLQv+RyKiOaYHK50ZrROeeDAsAGCVE=";
=======
    hash = "sha256-ULU+KBeE7T7qFQvw4KXz3/o2ZkZZa/C1QGqTPwlK7+c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiomqtt
  ];

  pythonImportsCheck = [ "letpot" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/jpelgrom/python-letpot/releases/tag/${src.tag}";
    description = "Asynchronous Python client for LetPot hydroponic gardens";
    homepage = "https://github.com/jpelgrom/python-letpot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
