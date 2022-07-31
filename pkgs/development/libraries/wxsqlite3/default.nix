{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, wxGTK
, sqlite
, Cocoa
, setfile
, rez
, derez
, wxmac
}:

stdenv.mkDerivation rec {
  pname = "wxsqlite3";
  version = "4.8.2";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    hash = "sha256-YoeCUyWVxpXY1QCTNONpv2QjV3rLZY84P6D3pXiWXo0=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ sqlite ]
    ++ lib.optionals (!stdenv.isDarwin) [ wxGTK ]
    ++ lib.optionals (stdenv.isDarwin) [ Cocoa setfile rez derez wxmac ];

  meta = with lib; {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "A C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
    license = with licenses; [ lgpl3Plus gpl3Plus ];
  };
}
