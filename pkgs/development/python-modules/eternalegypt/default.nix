{
  lib,
  aiohttp,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "eternalegypt";
  version = "0.0.17";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "amelchio";
    repo = "eternalegypt";
    tag = "v${version}";
    hash = "sha256-Qb8s8jU5yn7BIXVIV5cjwE0OnZOWEK8dzTmQDJM22rE=";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "eternalegypt" ];

  meta = with lib; {
    description = "Python API for Netgear LTE modems";
    homepage = "https://github.com/amelchio/eternalegypt";
    changelog = "https://github.com/amelchio/eternalegypt/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
