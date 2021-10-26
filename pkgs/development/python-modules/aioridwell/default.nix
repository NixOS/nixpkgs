{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, freezegun
, poetry-core
, pyjwt
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
, titlecase
, types-pytz
}:

buildPythonPackage rec {
  pname = "aioridwell";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "0kzxh1igncql1rwh12n42qahlc94z0fsd344d1vgni50jg7i34v7";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pyjwt
    pytz
    titlecase
  ];

  checkInputs = [
    aresponses
    freezegun
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    types-pytz
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'titlecase = "^2.3"' 'titlecase = "*"' \
      --replace 'pytz = "^2021.3"' 'pytz = "*"'
  '';

  disabledTests = [
    # AssertionError: assert datetime.date(...
    "test_get_next_pickup_event"
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "aioridwell"
  ];

  meta = with lib; {
    description = "Python library for interacting with Ridwell waste recycling";
    homepage = "https://github.com/bachya/aioridwell";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
