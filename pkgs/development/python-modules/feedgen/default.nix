{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  python-dateutil,
  lxml,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "feedgen";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2b1Rw7XpVqKlKZjDcIxNLHKfL8wxEYjh5dO5cmOTVGo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    lxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python module to generate ATOM feeds, RSS feeds and Podcasts";
    downloadPage = "https://github.com/lkiesow/python-feedgen/releases";
    homepage = "https://github.com/lkiesow/python-feedgen";
    license = with lib.licenses; [
      bsd2
      lgpl3
    ];
    maintainers = with lib.maintainers; [ casey ];
  };
})
