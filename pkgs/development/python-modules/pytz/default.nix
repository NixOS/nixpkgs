{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  tzdata,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytz";
  version = "2026.5";
  pyproject = true;

  src = fetchPypi {
    pname = "pytz";
    inherit (finalAttrs) version;
    hash = "sha256-+iNyS5xIZUO5/1SjJ+51aayDreVLua/Q/BhnZiBAHIY=";
  };

  postPatch = ''
    # Use our system-wide zoneinfo dir instead of the bundled one
    rm -rf pytz/zoneinfo
    ln -snvf ${tzdata}/share/zoneinfo pytz/zoneinfo
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [
    "--start-directory=pytz/tests"
  ];

  pythonImportsCheck = [ "pytz" ];

  meta = {
    changelog = "https://launchpad.net/pytz/+announcements";
    description = "World timezone definitions, modern and historical";
    homepage = "https://pythonhosted.org/pytz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
      jherland
    ];
  };
})
