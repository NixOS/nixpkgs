{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  fmt,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xbyak";
  version = "7.27";

  src = fetchFromGitHub {
    owner = "herumi";
    repo = "xbyak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MglzeHRbQgV6FPiald9J0xBBwylA4WUpy1a5p9JGVIw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ fmt ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JIT assembler for x86/x64 architectures supporting advanced instruction sets up to AVX10.2";
    homepage = "https://github.com/herumi/xbyak";
    maintainers = with lib.maintainers; [ marcin-serwin ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
