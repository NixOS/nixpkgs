{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "watcher";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "e-dant";
    repo = "watcher";
    tag = version;
    hash = "sha256-PpDeZBOdWJewZAyE1J1+IF8TxlkPXUuA9TDpQqtG8I4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Filesystem watcher. Works anywhere. Simple, efficient and friendly";
    homepage = "https://github.com/e-dant/watcher";
    changelog = "https://github.com/e-dant/watcher/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    mainProgram = "tw";
    platforms = lib.platforms.all;
  };
}
