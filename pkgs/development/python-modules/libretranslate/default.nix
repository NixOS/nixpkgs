{ lib
, appdirs
, apscheduler
, argos-translate-files
, argostranslate
, buildPythonPackage
, expiringdict
, fetchFromGitHub
, flask
, flask-babel
, flask-limiter
, flask-session
, flask-swagger
, flask-swagger-ui
, hatchling
, langdetect
, lexilang
, ltpycld2
, morfessor
, polib
, prometheus-client
, python
, pythonOlder
, pythonRelaxDepsHook
, redis
, requests
, translatehtml
, waitress
}:

buildPythonPackage rec {
  pname = "libretranslate";
  version = "1.5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "LibreTranslate";
    rev = "refs/tags/v${version}";
    hash = "sha256-8bbVpC53wH9GvwwHHlPEYQd/zqMXIqrwixwn4HY6FMg=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    appdirs
    apscheduler
    argos-translate-files
    argostranslate
    expiringdict
    flask
    flask-babel
    flask-limiter
    flask-session
    flask-swagger
    flask-swagger-ui
    langdetect
    lexilang
    ltpycld2
    morfessor
    polib
    prometheus-client
    redis
    requests
    translatehtml
    waitress
  ];

  postInstall = ''
    # expose static files to be able to serve them via web-server
    mkdir -p $out/share/libretranslate
    ln -s $out/${python.sitePackages}/libretranslate/static $out/share/libretranslate/static
  '';

  # Tests need network access
  doCheck = false;

  # required for import check to work (argostranslate)
  env.HOME = "/tmp";

  pythonImportsCheck = [
    "libretranslate"
  ];

  meta = with lib; {
    description = "Free and Open Source Machine Translation API. Self-hosted, no limits, no ties to proprietary services";
    homepage = "https://libretranslate.com";
    changelog = "https://github.com/LibreTranslate/LibreTranslate/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ misuzu ];
  };
}
