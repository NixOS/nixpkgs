{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  nix-update-script,
  uv-build,
  bdffont,
}:

buildPythonPackage rec {
  pname = "pcffont";
  version = "0.0.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "pcffont";
    tag = version;
    hash = "sha256-xxTOw7Fdey5YKDY1kq3EiAjW2jNHIU3wFDKvHdPgAQc=";
  };

  build-system = [ uv-build ];

  dependencies = [ bdffont ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pcffont" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/pcffont";
    description = "Library for manipulating Portable Compiled Format (PCF) Fonts";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
}
