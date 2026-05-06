{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  lxml,
  six,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "mbdata";
  version = "30.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "mbdata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FHA3bdEWuPBkvS+cyqVWpPfPaOlG0mCuchDcA0TWMuo=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    lxml
    six
    sqlalchemy
  ];

  pythonImportsCheck = [ "mbdata" ];

  meta = {
    description = "MusicBrainz database tools";
    downloadPage = "https://github.com/metabrainz/mbdata/releases";
    homepage = "https://github.com/metabrainz/mbdata";
    changelog = "https://github.com/metabrainz/mbdata/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
