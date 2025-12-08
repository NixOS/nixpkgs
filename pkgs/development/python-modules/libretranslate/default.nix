{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  runCommand,
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
  libretranslate,
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
  xorg,
}:

buildPythonPackage rec {
  pname = "libretranslate";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "LibreTranslate";
    tag = "v${version}";
    hash = "sha256-LzXAGiZQU6wV063bqLTr8S1IDX/j4xHjqmhuFyosCSw=";
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

  passthru = {
    static-compressed =
      runCommand "libretranslate-data-compressed"
        {
          nativeBuildInputs = [
            pkgs.brotli
            xorg.lndir
          ];
        }
        ''
          mkdir -p $out/share/libretranslate/static
          lndir ${libretranslate}/share/libretranslate/static $out/share/libretranslate/static

          # Create static gzip and brotli files
          find -L $out -type f -regextype posix-extended -iregex '.*\.(css|ico|js|svg|ttf)' \
            -exec gzip --best --keep --force {} ';' \
            -exec brotli --best --keep --no-copy-stat {} ';'
        '';
  };

  meta = with lib; {
    description = "Free and Open Source Machine Translation API. Self-hosted, no limits, no ties to proprietary services";
    homepage = "https://libretranslate.com";
    changelog = "https://github.com/LibreTranslate/LibreTranslate/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ misuzu ];
  };
}
