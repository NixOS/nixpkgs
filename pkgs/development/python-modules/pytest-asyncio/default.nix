{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  pytest,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "0.25.3"; # N.B.: when updating, tests bleak and aioesphomeapi tests
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-asyncio";
    tag = "v${version}";
    hash = "sha256-/uG8/uhKYeWrXifAJ7iqvpgXe70YduiqH8FSq2rD7f0=";
  };

  outputs = [
    "out"
    "testout"
  ];

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];

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
