{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  standard-telnetlib,
}:

buildPythonPackage rec {
  pname = "nad-receiver";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "joopert";
    repo = "nad_receiver";
    rev = version;
    hash = "sha256-jRMk/yMA48ei+g/33+mMYwfwixaKTMYcU/z/VOoJbvY=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial ] ++ lib.optionals (pythonAtLeast "3.13") [ standard-telnetlib ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nad_receiver" ];

  meta = with lib; {
    description = "Python interface for NAD receivers";
    homepage = "https://github.com/joopert/nad_receiver";
    changelog = "https://github.com/joopert/nad_receiver/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
