{ lib
, anyio
, buildPythonPackage
, curio
, fetchFromGitHub
, hypothesis
, pytest
, pytestCheckHook
, pythonOlder
, sniffio
, trio
, trio-asyncio
}:

buildPythonPackage rec {
  pname = "pytest-aio";
  version = "1.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "klen";
    repo = "pytest-aio";
    rev = version;
    sha256 = "pLH0yXe/KS9ohI8+hWSprP1OA3Qjki2BPqeApMPMGDs=";
  };

  postPatch = ''
    sed -i '/addopts/d' setup.cfg
  '';

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    anyio
    curio
    hypothesis
    pytestCheckHook
    sniffio
    trio
    trio-asyncio
  ];

  pythonImportsCheck = [
    "pytest_aio"
  ];

  meta = with lib; {
    homepage = "https://github.com/klen/pytest-aio";
    description = "Pytest plugin for aiohttp support";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
