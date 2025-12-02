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
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "liblistenbrainz";
    tag = "v${version}";
    hash = "sha256-2/EUzkC+8u6SQZYstIqJnlWcz74f5UpuXh/r4ImNd0g=";
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
