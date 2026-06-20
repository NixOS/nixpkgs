{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vmaware";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "kernelwernel";
    repo = "VMAware";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HaDKfSfxztRtMVwrvSFifZ8V4CMZjrNGzGzg+3Glcw8=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "-march=native" "" \
      --replace-fail "-mtune=native" "" \
      --replace-fail "DESTINATION /usr/bin" "DESTINATION $out/bin" \
      --replace-fail "DESTINATION /usr/include" "DESTINATION $out/include"
  '';

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
