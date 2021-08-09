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
}:

stdenv.mkDerivation rec {
  pname = "wxsqlite3";
  version = "4.6.4";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    sha256 = "sha256-fIm8xbNP7pjzvfBn7NgYmUtbVVh2aiaXQVANJQnrWCs=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ wxGTK sqlite ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa setfile rez derez ];

  meta = with lib; {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "A C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
    license = with licenses; [ lgpl3Plus gpl3Plus ];
  };
}
