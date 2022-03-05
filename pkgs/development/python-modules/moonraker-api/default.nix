{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "moonraker-api";
  version = "2.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cmroche";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hhm3jnl9qm44y4k927fzw1n32c3551kgsk7i57qw25nca9x3k61";
  };

  postPatch = ''
    # see comment on https://github.com/cmroche/moonraker-api/commit/e5ca8ab60d2839e150a81182fbe65255d84b4e4e
    substituteInPlace setup.py \
      --replace 'name="moonraker-api",' 'name="moonraker-api",version="${version}",'
  '';

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "moonraker_api"
  ];

  meta = with lib; {
    description = "Python API for the Moonraker API";
    homepage = "https://github.com/cmroche/moonraker-api";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
