{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-mockservers";
  version = "0.6.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Gr1N";
    repo = pname;
    rev = version;
    sha256 = "0xql0fnw7m2zn103601gqbpyd761kzvgjj2iz9hjsv56nr4z1g9i";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    aiohttp
    pytest-asyncio
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/Gr1N/pytest-mockservers/pull/75
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/Gr1N/pytest-mockservers/commit/c7731186a4e12851ab1c15ab56e652bb48ed59c4.patch";
      sha256 = "0yzqndn3a8732c8fgrxz396857s1ynlzz7yyvqn6idvh6b3gg5gz";
    })
  ];

  pythonImportsCheck = [ "pytest_mockservers" ];

  meta = with lib; {
    description = "Pytest fixtures to test requests to HTTP/UDP servers";
    homepage = "https://github.com/Gr1N/pytest-mockservers";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
