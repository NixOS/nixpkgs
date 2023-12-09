{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, pytest
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "0.23.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-j8nMxXhMbsKrVsFPNokWobmOkSxRDhvqsff/jruN+wY=";
  };

  outputs = [
    "out"
    "testout"
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  postInstall = ''
    mkdir $testout
    cp -R tests $testout/tests
  '';

  doCheck = false;
  passthru.tests.pytest = callPackage ./tests.nix {};

  pythonImportsCheck = [
    "pytest_asyncio"
  ];

  meta = with lib; {
    description = "Library for testing asyncio code with pytest";
    homepage = "https://github.com/pytest-dev/pytest-asyncio";
    changelog = "https://github.com/pytest-dev/pytest-asyncio/blob/v${version}/docs/source/reference/changelog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
