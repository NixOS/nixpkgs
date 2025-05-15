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

  meta = with lib; {
    homepage = "https://yash.osdn.jp/index.html.en";
    description = "Yet another POSIX-compliant shell";
    mainProgram = "yash";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qbit ];
    platforms = platforms.all;
  };

  passthru.shellPath = "/bin/yash";
}
