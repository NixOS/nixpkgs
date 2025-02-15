{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  mitmproxy,
  markupsafe,
}:

buildPythonPackage rec {
  pname = "http-tools";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "MobSF";
    repo = "httptools";
    rev = "refs/tags/${version}";
    hash = "sha256-TmAhxdMgqRtA4j269IqYl23BQCuNSR/mi07WVmkjfZU=";
  };

  propagatedBuildInputs = [
    mitmproxy
    markupsafe
  ];

  pythonImportsCheck = [ "http_tools" ];

  meta = {
    description = "httptools helps you to capture, repeat and live intercept HTTP requests with scripting capabilities";
    homepage = "https://github.com/MobSF/httptools";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ gamedungeon ];
  };
}
