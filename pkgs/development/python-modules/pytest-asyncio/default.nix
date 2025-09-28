{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  pythonOlder,
  pytest,
  setuptools-scm,
  backports-asyncio-runner,
}:

buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "1.1.0"; # N.B.: when updating, tests bleak and aioesphomeapi tests
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-asyncio";
    tag = "v${version}";
    hash = "sha256-+dLOzMPKI3nawfyZVZZ6hg6OkaEGZBp8oC5VIr7y0es=";
  };

  outputs = [
    "out"
    "testout"
  ];

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];
  dependencies = lib.optionals (pythonOlder "3.11") [
    backports-asyncio-runner
  ];

  postInstall = ''
    mkdir $testout
    cp -R tests $testout/tests
  '';

  doCheck = false;
  passthru.tests.pytest = callPackage ./tests.nix { };

  pythonImportsCheck = [ "pytest_asyncio" ];

  meta = with lib; {
    description = "Library for testing asyncio code with pytest";
    homepage = "https://github.com/pytest-dev/pytest-asyncio";
    changelog = "https://github.com/pytest-dev/pytest-asyncio/blob/${src.tag}/docs/reference/changelog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
