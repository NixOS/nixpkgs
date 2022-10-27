{ lib
, buildPythonPackage
, fetchFromGitHub
, asynctest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dynalite-devices";
  version = "0.47";

  src = fetchFromGitHub {
    owner = "ziv1234";
    repo = "python-dynalite-devices";
    rev = "refs/tags/v${version}"; # https://github.com/ziv1234/python-dynalite-devices/issues/2
    hash = "sha256-kJo4e5vhgWzijLUhQd9VBVk1URpg9SXhOA60dJYashM=";
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

  checkInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

  pythonImportsCheck = [ "dynalite_devices_lib" ];

  meta = with lib; {
    description = "An unofficial Dynalite DyNET interface creating devices";
    homepage = "https://github.com/ziv1234/python-dynalite-devices";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
