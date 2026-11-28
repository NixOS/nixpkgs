{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "myuplink";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pajzo";
    repo = "myuplink";
    tag = version;
    hash = "sha256-/9gKaNvb8U15hGo1sar13dnJOgxQ2/Zd+uMcQnG2uC8=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "%%VERSION_NO%%" "${version}"
  '';

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "myuplink" ];

  meta = {
    description = "Module to interact with the myUplink API";
    homepage = "https://github.com/pajzo/myuplink";
    changelog = "https://github.com/pajzo/myuplink/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
