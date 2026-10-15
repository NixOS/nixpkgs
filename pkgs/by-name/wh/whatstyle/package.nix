{
  lib,
  python3Packages,
  fetchFromGitHub,
  llvmPackages,
}:

let
  inherit (llvmPackages) clang-unwrapped;
in

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "whatstyle";
  version = "0.2.0";
  format = "setuptools";
  src = fetchFromGitHub {
    owner = "mikr";
    repo = "whatstyle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4LCZAEUQFPl4CBPeuqsodiAlwd8uBg+SudF5d+Vz4Gc=";
  };

  # Fix references to previous version, to avoid confusion:
  postPatch = ''
    substituteInPlace setup.py --replace-fail 0.1.9 ${finalAttrs.version}
    substituteInPlace whatstyle.py --replace-fail 0.1.9 ${finalAttrs.version}
  '';

  nativeCheckInputs = [
    clang-unwrapped # clang-format
  ];

  doCheck = false; # 3 or 4 failures depending on version, haven't investigated.

  meta = {
    description = "Find a code format style that fits given source files";
    mainProgram = "whatstyle";
    homepage = "https://github.com/mikr/whatstyle";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
