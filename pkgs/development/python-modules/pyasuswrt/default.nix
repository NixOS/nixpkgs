{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyasuswrt";
  version = "0.1.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ollo69";
    repo = "pyasuswrt";
    tag = "v${version}";
    hash = "sha256-kg475AWmc0i/W4dBg8jFmNyz3V67xjvzPkSlS09/9Oc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];

  # Tests require physical hardware
  doCheck = false;

  pythonImportsCheck = [ "pyasuswrt" ];

  meta = {
    description = "Library for communication with ASUSWRT routers via HTTP";
    homepage = "https://github.com/ollo69/pyasuswrt";
    changelog = "https://github.com/ollo69/pyasuswrt/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
