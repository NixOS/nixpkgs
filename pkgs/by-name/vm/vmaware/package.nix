{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vmaware";
  version = "2.8.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kernelwernel";
    repo = "VMAware";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KPjIk5nm27RcxGg3owfLVt+b1sL0y90IPPgeGv7fTgQ=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform C++ library and CLI tool for virtual machine detection";
    homepage = "https://github.com/kernelwernel/VMAware";
    changelog = "https://github.com/kernelwernel/VMAware/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ patrickdag ];
    platforms = lib.platforms.linux;
    mainProgram = "vmaware";
  };
})
