{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  hatchling,
  argostranslate,
  flask,
  flask-swagger,
  flask-swagger-ui,
  flask-limiter,
  flask-babel,
  flask-session,
  waitress,
  expiringdict,
  langdetect,
  lexilang,
  ltpycld2,
  morfessor,
  appdirs,
  apscheduler,
  translatehtml,
  argos-translate-files,
  requests,
  redis,
  prometheus-client,
  polib,
  python,
}:

buildPythonPackage rec {
  pname = "libretranslate";
  version = "1.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "LibreTranslate";
    tag = "v${version}";
    hash = "sha256-fzBVEJnj7sCkfNIIFZXHB0VQt94z0U9lbtW6+abAMpA=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = true;

  dependencies = [
    argostranslate
    flask
    flask-swagger
    flask-swagger-ui
    flask-limiter
    flask-babel
    flask-session
    waitress
    expiringdict
    langdetect
    lexilang
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

  postInstall = ''
    # expose static files to be able to serve them via web-server
    mkdir -p $out/share/libretranslate
    ln -s $out/${python.sitePackages}/libretranslate/static $out/share/libretranslate/static
  '';

  doCheck = false; # needs network access

  nativeCheckInputs = [ pytestCheckHook ];

  # required for import check to work (argostranslate)
  env.HOME = "/tmp";

  pythonImportsCheck = [ "libretranslate" ];

  meta = with lib; {
    description = "Free and Open Source Machine Translation API. Self-hosted, no limits, no ties to proprietary services";
    homepage = "https://libretranslate.com";
    changelog = "https://github.com/LibreTranslate/LibreTranslate/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ misuzu ];
  };
}
