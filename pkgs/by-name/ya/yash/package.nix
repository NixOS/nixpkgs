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
  version = "2.59";

  src = fetchFromGitHub {
    owner = "magicant";
    repo = "yash";
    rev = version;
    hash = "sha256-HTKodWcP7K2DLggELSi4TkFezjb3bhMRXiLenBEZoaQ=";
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
}
