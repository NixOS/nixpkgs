{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  pythonOlder,
  pytest,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "1.3.0"; # N.B.: when updating, tests bleak and aioesphomeapi tests
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-asyncio";
    tag = "v${version}";
    hash = "sha256-MWKMJkvxdvuOyxE8rNlf15j7C+MwJibnNsbfS0biKwo=";
  };

  outputs = [
    "out"
    "testout"
  ];

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];

  dependencies = lib.optionals (pythonOlder "3.13") [
    typing-extensions
  ];

  postInstall = ''
    mkdir $testout
    cp -R tests $testout/tests
  '';

  doCheck = false;
  passthru.tests.pytest = callPackage ./tests.nix { };

  pythonImportsCheck = [ "pytest_asyncio" ];

  meta = {
    description = "Library for testing asyncio code with pytest";
    homepage = "https://github.com/pytest-dev/pytest-asyncio";
    changelog = "https://github.com/pytest-dev/pytest-asyncio/blob/${src.tag}/docs/reference/changelog.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
