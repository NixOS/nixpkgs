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
  version = "4.7.6";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    hash = "sha256-QoICP66eluD5phYVi1iK8tg1FL04EQjY29/4n6SIz3s=";
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
