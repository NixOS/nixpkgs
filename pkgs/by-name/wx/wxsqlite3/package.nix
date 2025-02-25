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
  version = "4.10.3";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    hash = "sha256-XoGysM5Btm9MdeaS2eAOEn7j/Do0+1sqC/tGIkWnkxw=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    sqlite
    wxGTK32
  ];

  meta = with lib; {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = platforms.unix;
    maintainers = [ ];
    license = with licenses; [
      lgpl3Plus
      gpl3Plus
    ];
  };
}
