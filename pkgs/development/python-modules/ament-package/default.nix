{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ament-package";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ament";
    repo = "ament_package";
    tag = finalAttrs.version;
    hash = "sha256-4NLrRcBM82Bu8hDufma3z5li/kJQCyJEJma0UBBBvKw=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "ament_package" ];

  # Tests currently broken
  doCheck = false;

  # The script selects tag release-alpha8
  passthru.skipBulkUpdate = true;

  meta = {
    changelog = "https://github.com/ament/ament_package/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Parser for the manifest files in the ament buildsystem";
    homepage = "https://github.com/ament/ament_package";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
