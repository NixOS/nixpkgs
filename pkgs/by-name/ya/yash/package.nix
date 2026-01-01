{
  stdenv,
  lib,
  fetchFromGitHub,
  gettext,
  ncurses,
  asciidoc,
}:

stdenv.mkDerivation rec {
  pname = "yash";
  version = "2.60";

  src = fetchFromGitHub {
    owner = "magicant";
    repo = "yash";
    rev = version;
    hash = "sha256-iHM1f+zdYsfuqmyel+vlFi+TQukmN91SyZCHJLXPnTs=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    asciidoc
    gettext
  ];
  buildInputs = [ ncurses ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ gettext ];

<<<<<<< HEAD
  meta = {
    homepage = "https://yash.osdn.jp/index.html.en";
    description = "Yet another POSIX-compliant shell";
    mainProgram = "yash";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qbit ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "https://yash.osdn.jp/index.html.en";
    description = "Yet another POSIX-compliant shell";
    mainProgram = "yash";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qbit ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  passthru.shellPath = "/bin/yash";
}
