{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  requests,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "liblistenbrainz";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "liblistenbrainz";
    tag = version;
    hash = "sha256-fZgIVGDUJ4Dh/7CIOugvpRP7FoijpsgA3bBKJMmDd7o=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "liblistenbrainz" ];

  meta = {
    description = "Simple ListenBrainz client library for Python";
    homepage = "https://github.com/metabrainz/liblistenbrainz";
    changelog = "https://github.com/metabrainz/liblistenbrainz/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.ngi ];
  };
}
