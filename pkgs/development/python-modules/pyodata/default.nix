{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  httpx,
  pytest-aiohttp,
  pytestCheckHook,
  requests,
  responses,
  respx,
}:

buildPythonPackage rec {
  pname = "pyodata";
  version = "1.12.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "SAP";
    repo = "python-pyodata";
    tag = version;
    hash = "sha256-OdpUDQDpX1xjw59mbbHpeMA+WN6mKn53QvNU63p3AF0=";
  };

  dependencies = [ lxml ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
    requests
    responses
    httpx
    respx
  ];

  pythonImportsCheck = [ "pyodata" ];

  meta = {
    description = "Enterprise ready Python OData client";
    homepage = "https://github.com/SAP/python-pyodata";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
