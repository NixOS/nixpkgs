{
  lib,
  aiohttp,
  buildPythonPackage,
  faker,
  fetchFromGitHub,
  pytest-aiohttp,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiolookin";
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ANMalko";
    repo = "aiolookin";
    tag = "v${version}";
    hash = "sha256-G3/lUgV60CMLskUo83TlvLLIfJtu5DEz+94mdVI4OrI=";
  };

  propagatedBuildInputs = [ aiohttp ];

  doCheck = false; # all tests are async and no async plugin is configured

  nativeCheckInputs = [
    faker
    pytest-aiohttp
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiolookin" ];

  meta = {
    description = "Python client for interacting with LOOKin devices";
    homepage = "https://github.com/ANMalko/aiolookin";
    changelog = "https://github.com/ANMalko/aiolookin/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
