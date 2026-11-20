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
  version = "0.0.35";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TakWolf";
    repo = "pcffont-python";
    tag = version;
    hash = "sha256-/ysGjrkeH0nXFO88aMYu4uUq0Ct8IlV1mT7ETB9wJcg=";
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
    homepage = "https://github.com/TakWolf/pcffont-python";
    description = "Library for manipulating Portable Compiled Format (PCF) Fonts";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
}
