{
  lib,
  buildPythonPackage,
  cython_0,
  distutils,
  email-validator,
  fetchFromGitHub,
  pytest-mock,
  pytest7CheckHook,
  python-dotenv,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  typing-extensions,
  libxcrypt,
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "1.10.18";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    rev = "refs/tags/v${version}";
    hash = "sha256-IFctgyZAURVlUAYppwWjGU1k7Alo9w28CQfhdSjxZJ8=";
  };

  build-system = [
    setuptools
    cython_0
  ];

  buildInputs = lib.optionals (pythonOlder "3.9") [ libxcrypt ];

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    dotenv = [ python-dotenv ];
    email = [ email-validator ];
  };

  nativeCheckInputs = [
    distutils
    pytest-mock
    pytest7CheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  enableParallelBuilding = true;

  pythonImportsCheck = [ "pydantic" ];

  meta = with lib; {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
