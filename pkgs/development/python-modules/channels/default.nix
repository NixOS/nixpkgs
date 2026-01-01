{
  lib,
  asgiref,
  buildPythonPackage,
  daphne,
  django,
  fetchFromGitHub,
  async-timeout,
  pytest-asyncio,
  pytest-django,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "channels";
  version = "4.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django";
    repo = "channels";
    tag = version;
    hash = "sha256-KBjxaK2j9Xbz35IHqZK68cSLkUk4B7t+J7omcQAtuFM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asgiref
    django
  ];

  optional-dependencies = {
    daphne = [ daphne ];
  };

  nativeCheckInputs = [
    async-timeout
    pytest-asyncio
    pytest-django
    pytestCheckHook
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # won't run in sandbox
  disabledTestPaths = [
    "tests/sample_project/tests/test_selenium.py"
  ];

  pythonImportsCheck = [ "channels" ];

<<<<<<< HEAD
  meta = {
    description = "Brings event-driven capabilities to Django with a channel system";
    homepage = "https://github.com/django/channels";
    changelog = "https://github.com/django/channels/blob/${src.tag}/CHANGELOG.txt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Brings event-driven capabilities to Django with a channel system";
    homepage = "https://github.com/django/channels";
    changelog = "https://github.com/django/channels/blob/${src.tag}/CHANGELOG.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
