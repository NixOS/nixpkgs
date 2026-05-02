{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "isocodes";
  version = "2025.8.25";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;

    hash = "sha256-xayFWmml1Op/m1eB8X1sD3CQXTjpJBgsJjyKAPnblKI=";
  };

  build-system = [
    setuptools
  ];

  meta = {
    changelog = "https://github.com/Atem18/isocodes/releases/tag/${finalAttrs.version}";
    description = "Lists of ISO standard codes (country, language, etc.)";
    homepage = "https://github.com/Atem18/isocodes";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ chordtoll ];
  };
})
