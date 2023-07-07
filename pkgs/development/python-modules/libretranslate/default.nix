{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, argostranslate
, flask
, flask-swagger
, flask-swagger-ui
, flask-limiter
, flask-babel
, flask-session
, waitress
, expiringdict
, ltpycld2
, morfessor
, appdirs
, apscheduler
, translatehtml
, argos-translate-files
, requests
, redis
, prometheus-client
, polib
}:

buildPythonPackage rec {
  pname = "libretranslate";
  version = "1.3.11";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "LibreTranslate";
    rev = "refs/tags/v${version}";
    hash = "sha256-S2J7kcoZFHOjVm2mb3TblWf9/FzkxZEB3h27BCaPYgY=";
  };

  propagatedBuildInputs = [
    argostranslate
    flask
    flask-swagger
    flask-swagger-ui
    flask-limiter
    flask-babel
    flask-session
    waitress
    expiringdict
    ltpycld2
    morfessor
    appdirs
    apscheduler
    translatehtml
    argos-translate-files
    requests
    redis
    prometheus-client
    polib
  ];

  postPatch = ''
    substituteInPlace requirements.txt  \
      --replace "==" ">="

    substituteInPlace setup.py  \
      --replace "'pytest-runner'" ""
  '';

  postInstall = ''
    # expose static files to be able to serve them via web-server
    mkdir -p $out/share/libretranslate
    ln -s $out/lib/python*/site-packages/libretranslate/static $out/share/libretranslate/static
  '';

  doCheck = false; # needs network access

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # required for import check to work (argostranslate)
  env.HOME = "/tmp";

  pythonImportsCheck = [ "libretranslate" ];

  meta = with lib; {
    description = "Free and Open Source Machine Translation API. Self-hosted, no limits, no ties to proprietary services";
    homepage = "https://libretranslate.com";
    changelog = "https://github.com/LibreTranslate/LibreTranslate/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ misuzu ];
  };
}
