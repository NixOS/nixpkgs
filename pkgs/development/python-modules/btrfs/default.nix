{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "btrfs";
  version = "15";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-FBmRT/FB3+nhb9BHfZVI1L6nM+zXdYjoy3JVzhetoQs=";
  };

  build-system = [ setuptools ];

  # currently no tests
  doCheck = false;

  pythonImportsCheck = [ "btrfs" ];

  meta = {
    description = "Inspect btrfs filesystems";
    homepage = "https://github.com/knorrie/python-btrfs";
    changelog = "https://github.com/knorrie/python-btrfs/blob/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      Luflosi
    ];
  };
})
