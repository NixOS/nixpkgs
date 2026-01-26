{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mitmproxy,
  markupsafe,
}:

buildPythonPackage rec {
  pname = "http-tools";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MobSF";
    repo = "httptools";
    tag = version;
    hash = "sha256-TmAhxdMgqRtA4j269IqYl23BQCuNSR/mi07WVmkjfZU=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    mitmproxy
    markupsafe
  ];

  pythonRelaxDepsHook = [
    "mitmproxy"
  ];

  postPatch = ''
    sed -i 's/mitmproxy==[0-9\.]*/mitmproxy/' setup.py
  '';

  # TODO
  #pythonImportsCheck = [ "httptools" ];

  meta = {
    description = "httptools helps you to capture, repeat and live intercept HTTP requests with scripting capabilities. It is built on top of mitmproxy";
    homepage = "https://github.com/MobSF/httptools";
    changelog = "https://github.com/MobSF/httptools/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
