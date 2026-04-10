{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "korean-lunar-calendar";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "korean_lunar_calendar";
    hash = "sha256-vlbye8BZT9u997vgD1BKn5KaMeMRvX2buTVhtkWvrec=";
  };

  build-system = [ setuptools ];

  # no real tests
  pythonImportsCheck = [ "korean_lunar_calendar" ];

  meta = {
    description = "Library to convert Korean lunar-calendar to Gregorian calendar";
    homepage = "https://github.com/usingsky/korean_lunar_calendar_py";
    changelog = "https://github.com/usingsky/korean_lunar_calendar_py/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ris ];
  };
})
