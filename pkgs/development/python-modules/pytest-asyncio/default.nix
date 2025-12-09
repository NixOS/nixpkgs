{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  pythonOlder,
  pytest,
  setuptools-scm,
  backports-asyncio-runner,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "1.2.0"; # N.B.: when updating, tests bleak and aioesphomeapi tests
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-asyncio";
    tag = "v${version}";
    hash = "sha256-27FCV7zgFGe/Q0fkYyh5Z05foVGhbKBRPTH4UK/tW5A=";
  };

  outputs = [
    "out"
    "testout"
  ];

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];

  dependencies = [
    backports-asyncio-runner
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    typing-extensions
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
