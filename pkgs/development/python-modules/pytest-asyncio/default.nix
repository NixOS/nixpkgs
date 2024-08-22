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
  version = "0.24.0"; # N.B.: when updating, tests bleak and aioesphomeapi tests
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-asyncio";
    rev = "refs/tags/v${version}";
    hash = "sha256-4/wRDQz0kotUdSK7Z55IpW15W+tIvX8oH7dpsmxjohw=";
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
    changelog = "https://github.com/pytest-dev/pytest-asyncio/blob/v${version}/docs/reference/changelog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
