{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  regex,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lb-matching-tools";
  version = "2024.01.30.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "listenbrainz-matching-tools";
    tag = "v${version}";
    hash = "sha256-RQ4X6DKigQsNxaAWXB1meATKP+ddMUgkoAIyX8iIisU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ regex ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lb_matching_tools" ];

  meta = {
    description = "ListenBrainz tools for matching metadata to and from MusicBrainz";
    homepage = "https://github.com/metabrainz/listenbrainz-matching-tools";
    changelog = "https://github.com/metabrainz/listenbrainz-matching-tools/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.ngi ];
  };
}
