{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
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
    rev = "refs/tags/${version}";
    hash = "sha256-TmAhxdMgqRtA4j269IqYl23BQCuNSR/mi07WVmkjfZU=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    mitmproxy
    markupsafe
  ];

  pythonRelaxDeps = [ "mitmproxy" ];

  pythonImportsCheck = [ "http_tools" ];

  meta = {
    description = "httptools helps you to capture, repeat and live intercept HTTP requests with scripting capabilities";
    homepage = "https://github.com/MobSF/httptools";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ gamedungeon ];
  };
}
