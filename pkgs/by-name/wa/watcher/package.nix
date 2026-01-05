{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "watcher";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "e-dant";
    repo = "watcher";
    tag = version;
    hash = "sha256-UO17PcLVsPgSFOfCPFth/SzEQaZRcXWPHKQFLTrPnEU=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Filesystem watcher. Works anywhere. Simple, efficient and friendly";
    homepage = "https://github.com/e-dant/watcher";
    changelog = "https://github.com/e-dant/watcher/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gaelreyrol
      matthiasbeyer
    ];
    mainProgram = "tw";
    platforms = lib.platforms.all;
  };
}
