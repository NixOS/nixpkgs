{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "aiopvpc";
  version = "2.0.2";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "azogue";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ajs4kbdlfn4h7f3d6lwkp4yl1rl7zyvj997nhsz93jjwxbajkpv";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pytz
    async-timeout
  ];

  checkInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/azogue/aiopvpc/pull/10
    (fetchpatch {
      name = "use-peotry-core.patch";
      url = "https://github.com/azogue/aiopvpc/commit/4bc2740ffd485a60acf579b4f3eb5ee6a353245c.patch";
      sha256 = "0ynj7pqq3akdvdrvqcwnnslay3mn1q92qhk8fg95ppflzscixli6";
    })
  ];

  postPatch = ''
    substituteInPlace pytest.ini --replace \
      " --cov --cov-report term --cov-report html" ""
  '';

  pythonImportsCheck = [ "aiopvpc" ];

  meta = with lib; {
    description = "Python module to download Spanish electricity hourly prices (PVPC)";
    homepage = "https://github.com/azogue/aiopvpc";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
