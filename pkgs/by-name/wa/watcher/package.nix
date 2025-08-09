{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "watcher";
  version = "0.13.6";

  src = fetchFromGitHub {
    owner = "e-dant";
    repo = "watcher";
    tag = version;
    hash = "sha256-mcnItyXjU4ylNvM6QLlmUDybhwdxi7D6e3z8saZubMY=";
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
