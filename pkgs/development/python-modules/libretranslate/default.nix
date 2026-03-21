{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
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
  lndir,
}:

buildPythonPackage (finalAttrs: {
  pname = "libretranslate";
  version = "1.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LibreTranslate";
    repo = "LibreTranslate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VcMo1GX+ituQOW8Dpt0ABJG5fsJbFuxAPmi59Byg5ww=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = true;

  # LibreTranslate has forked argos-translate [1] to fix some bugs and make stanza optional, but it's
  # unclear what the future of this fork is.
  #
  # We'll stay on upstream argostranslate for now.
  #
  # [1]: https://github.com/Libretranslate/argos-translate/
  pythonRemoveDeps = [ "argos-translate-lt" ];

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

  # needed to import the argostranslate module
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  pythonImportsCheck = [ "libretranslate" ];

  passthru = {
    static-compressed =
      runCommand "libretranslate-data-compressed"
        {
          nativeBuildInputs = [
            pkgs.brotli
            lndir
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

  meta = {
    description = "Free and Open Source Machine Translation API. Self-hosted, no limits, no ties to proprietary services";
    homepage = "https://libretranslate.com";
    changelog = "https://github.com/LibreTranslate/LibreTranslate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ misuzu ];
  };
})
