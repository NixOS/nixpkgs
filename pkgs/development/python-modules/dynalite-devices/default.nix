{ lib
, buildPythonPackage
, fetchFromGitHub
, asynctest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dynalite-devices";
  version = "0.1.46";

  src = fetchFromGitHub {
    owner = "ziv1234";
    repo = "python-dynalite-devices";
    rev = "v0.46"; # https://github.com/ziv1234/python-dynalite-devices/issues/2
    hash = "sha256-Fju2JpFkQBCbOln7r3L+crv82TI2SkdPJ1oaK7PEifo=";
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

  checkInputs = [
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dynalite_devices_lib" ];

  meta = with lib; {
    description = "An unofficial Dynalite DyNET interface creating devices";
    homepage = "https://github.com/ziv1234/python-dynalite-devices";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
