{
  stdenv,
  lib,
  fetchFromGitHub,
  gettext,
  ncurses,
  asciidoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yash";
  version = "2.61";

  src = fetchFromGitHub {
    owner = "magicant";
    repo = "yash";
    rev = finalAttrs.version;
    hash = "sha256-ih5BXzhG/DNeWghptXXTXVbZLT63AE8blWTzzfssqXU=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    asciidoc
    gettext
  ];
  buildInputs = [ ncurses ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ gettext ];

  meta = {
    homepage = "https://yash.osdn.jp/index.html.en";
    description = "Yet another POSIX-compliant shell";
    mainProgram = "yash";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qbit ];
    platforms = lib.platforms.all;
  };

  passthru.shellPath = "/bin/yash";
})
