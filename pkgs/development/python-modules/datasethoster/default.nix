{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  pydantic_1,
  sentry-sdk,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "datasethoster";
  version = "0.1-unstable-2024-05-01";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "data-set-hoster";
    rev = "830ecb2b2120acbd5deed2dab4587784c7be04b6";
    hash = "sha256-zZgSEVX686Wne3tp/Qtrr4PjlC4GwvFrjsBPD5AYYtM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    pydantic_1
    sentry-sdk
    six
  ];

  pythonImportsCheck = [ "datasethoster" ];

  meta = {
    description = "Super simple data set hoster";
    homepage = "https://github.com/metabrainz/data-set-hoster";
    changelog = "https://github.com/metabrainz/data-set-hoster/commit/${finalAttrs.src.rev}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
