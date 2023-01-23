{ lib
, atomicwrites
, buildPythonPackage
, fetchFromGitHub
  #, hatchling
, ruamel-yaml
, poetry-core
, pytest
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, testfixtures
}:

buildPythonPackage rec {
  pname = "pytest-golden";
  version = "0.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "oprypin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-l5fXWDK6gWJc3dkYFTokI9tWvawMRnF0td/lSwqkYXE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry>=0.12" poetry-core \
      --replace poetry.masonry.api poetry.core.masonry.api
  '';

  pythonRelaxDeps = [
    "testfixtures"
  ];

  nativeBuildInputs = [
    # hatchling used for > 0.2.2
    poetry-core
    pythonRelaxDepsHook
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    atomicwrites
    ruamel-yaml
    testfixtures
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_golden"
  ];

  meta = with lib; {
    description = "Plugin for pytest that offloads expected outputs to data files";
    homepage = "https://github.com/oprypin/pytest-golden";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
