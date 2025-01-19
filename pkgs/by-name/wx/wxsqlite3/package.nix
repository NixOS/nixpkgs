{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wxGTK32,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "wxsqlite3";
  version = "4.10.1";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    hash = "sha256-pCmhDmJLR+2GZJEyF7zW4BtSz7mTJ/WZXQB+KXaqIkA=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    sqlite
    wxGTK32
  ];

  meta = {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    license = with lib.licenses; [
      lgpl3Plus
      gpl3Plus
    ];
  };
}
