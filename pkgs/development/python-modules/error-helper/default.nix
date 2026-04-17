{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "error_helper";
  version = "1.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;

    hash = "sha256-7kbzGmidsZzhoE5p9Ddjn6oDc+HUzkN02ykS0e0JodY=";
  };

  build-system = [
    hatchling
  ];

  meta = {
    changelog = "https://github.com/30350n/error_helper/releases/tag/v${finalAttrs.version}";
    description = "Prints colorful error messages";
    homepage = "https://github.com/30350n/error_helper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chordtoll ];
  };
})
