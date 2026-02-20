{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "watcher";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "e-dant";
    repo = "watcher";
    tag = finalAttrs.version;
    hash = "sha256-V3s7IpnDJMV0ojNcJhg+15VXQviZptu2hB5oE/2B5Hw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Filesystem watcher. Works anywhere. Simple, efficient and friendly";
    homepage = "https://github.com/e-dant/watcher";
    changelog = "https://github.com/e-dant/watcher/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "tw";
    platforms = lib.platforms.all;
  };
})
