{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mitmproxy,
  markupsafe,
}:

buildPythonPackage (finalAttrs: {
  pname = "http-tools";
  version = "6.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MobSF";
    repo = "httptools";
    tag = finalAttrs.version;
    hash = "sha256-ZQLrWAAImVt8AzCPXbza+Ee68P8xwGU+kPVkPStMxSI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mitmproxy
    markupsafe
  ];

  pythonRelaxDeps = [
    "mitmproxy"
  ];

  pythonImportsCheck = [ "http_tools" ];

  meta = {
    description = "httptools helps you to capture, repeat and live intercept HTTP requests with scripting capabilities. It is built on top of mitmproxy";
    homepage = "https://github.com/MobSF/httptools";
    changelog = "https://github.com/MobSF/httptools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
