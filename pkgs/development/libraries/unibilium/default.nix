{
  stdenv,
  lib,
  fetchFromGitHub,
  libtool,
  pkg-config,
  perl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "unibilium";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "unibilium";
    rev = "v${version}";
    sha256 = "sha256-A/WECvma7u/Mmecvzi0cP168dt4v+zwC8CiFBkqWezA=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "LIBTOOL=${libtool}/bin/libtool"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    perl
    libtool
  ];
  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "A very basic terminfo library";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
