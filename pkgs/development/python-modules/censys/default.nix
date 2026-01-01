{
  lib,
  argcomplete,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  parameterized,
  poetry-core,
  pytest-mock,
  pytest-cov-stub,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  requests,
  requests-mock,
  responses,
  rich,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "censys";
<<<<<<< HEAD
  version = "2.2.19";
  pyproject = true;

=======
  version = "2.2.18";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "censys";
    repo = "censys-python";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-3eQtGCIKtjpDWfyrIEPZnA6xLMNl0cg61wh0nuwNwh4=";
=======
    hash = "sha256-fHqDXqhjqfj8VBb7Od7wuUXAEHQBXwm5LAUPLM0oN2Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
    argcomplete
    backoff
    requests
    rich
    importlib-metadata
  ];

  nativeCheckInputs = [
    parameterized
    pytest-mock
    pytest-cov-stub
    pytestCheckHook
    requests-mock
    responses
    writableTmpDirAsHomeHook
  ];

  # The tests want to write a configuration file
  preCheck = ''
    mkdir -p $HOME
  '';

  pythonImportsCheck = [ "censys" ];

<<<<<<< HEAD
  meta = {
    description = "Python API wrapper for the Censys Search Engine (censys.io)";
    homepage = "https://github.com/censys/censys-python";
    changelog = "https://github.com/censys/censys-python/releases/tag/v${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python API wrapper for the Censys Search Engine (censys.io)";
    homepage = "https://github.com/censys/censys-python";
    changelog = "https://github.com/censys/censys-python/releases/tag/v${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "censys";
  };
}
