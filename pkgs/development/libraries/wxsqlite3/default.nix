{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, wxGTK
, sqlite
, darwin
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
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa darwin.stubs.setfile darwin.stubs.rez darwin.stubs.derez ];

  meta = with lib; {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "A C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
    license = [ licenses.lgpl3Plus licenses.gpl3Plus ];
  };
}
