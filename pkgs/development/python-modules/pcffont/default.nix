{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  nix-update-script,
  uv-build,
  bdffont,
  freetype-py,
}:

buildPythonPackage rec {
  pname = "pcffont";
  version = "0.0.33";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "pcffont";
    tag = version;
    hash = "sha256-inK/+oQkWfhIwhUjN3TkKvyk0AAxoliSsUzR84tLt9U=";
  };

  build-system = [ uv-build ];

  nativeCheckInputs = [
    pytestCheckHook
    bdffont
    freetype-py
  ];

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
