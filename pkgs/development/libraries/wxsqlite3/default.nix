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
<<<<<<< HEAD
  version = "4.9.4";
=======
  version = "4.9.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-aM79DI/Kj1QEIJ1HMttlfqK/WZER9RJhQbrnbPto57U=";
=======
    hash = "sha256-HdsPCdZF1wMTGYFaXzq+f4bUFjgCAklsKhhdyMKaxp8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ sqlite wxGTK ]
    ++ lib.optionals (stdenv.isDarwin) [ Cocoa setfile rez derez ];

  meta = with lib; {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "A C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
    license = with licenses; [ lgpl3Plus gpl3Plus ];
  };
}
