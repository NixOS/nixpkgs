{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  urllib3,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "asusrouter";
<<<<<<< HEAD
  version = "1.21.3";
=======
  version = "1.21.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Vaskivskyi";
    repo = "asusrouter";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-7OmuJ3VKBdg5hK8RAkA8DQGd4L+g9S17VT0B5JhNaSA=";
=======
    hash = "sha256-SMQ1jEEMRngl0idWXi7R7KinxR9NnH39vB/itVi7A4A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==80.9.0" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    urllib3
    xmltodict
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "asusrouter" ];

  meta = {
    description = "API wrapper for communication with ASUSWRT-powered routers using HTTP protocol";
    homepage = "https://github.com/Vaskivskyi/asusrouter";
    changelog = "https://github.com/Vaskivskyi/asusrouter/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
