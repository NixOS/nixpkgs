{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  wxGTK,
  sqlite,
  Cocoa,
  setfile,
  rez,
  derez,
}:

stdenv.mkDerivation rec {
  pname = "wxsqlite3";
  version = "4.9.12";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    hash = "sha256-WiOAF1yg18W4Vyyy+rzRe87GQTemvn32bexit4M/HjE=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs =
    [
      sqlite
      wxGTK
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      Cocoa
      setfile
      rez
      derez
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
