{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  stevedore,
  wheel,
}:

buildPythonPackage rec {
  pname = "plux";
  version = "1.5.0";
  pyproject = true;

  # Tests are not available from PyPi
  src = fetchFromGitHub {
    owner = "localstack";
    repo = "plux";
    rev = "refs/tags/v${version}";
    hash = "sha256-XHRQTgvxXJCjCD/9Invf/5OCtp12A5poRUv8tR9DJsk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ stevedore ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "plugin.core" ];

  meta = with lib; {
    description = "Dynamic code loading framework for building pluggable Python distributions";
    homepage = "https://github.com/localstack/plux";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
