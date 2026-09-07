{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "error-helper";
  version = "1.5";
  pyproject = true;
  __structuredAttrs = true;

  # GitHub source doesn't build correctly (fails imports check)
  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "error_helper";
    hash = "sha256-7kbzGmidsZzhoE5p9Ddjn6oDc+HUzkN02ykS0e0JodY=";
  };

  build-system = [
    hatchling
  ];

  # No tests in the Pypi archive.
  doCheck = false;

  pythonImportsCheck = [ "error_helper" ];

  meta = {
    description = "Minimalistic python module to print colorful messages";
    homepage = "https://github.com/30350n/error_helper";
    changelog = "https://github.com/30350n/error_helper/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gigahawk
    ];
  };
})
