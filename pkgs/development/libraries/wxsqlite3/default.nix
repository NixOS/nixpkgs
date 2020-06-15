{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, sqlite
, darwin
, withGtk2 ? false, wxGTK30-gtk2 ? null, wxGTK30-gtk3 ? null
}:

stdenv.mkDerivation rec {
  pname = "wxsqlite3-gtk${toString (if withGtk2 then 2 else 3)}";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    sha256 = "0090f7r3blks18vifkna4l890fwaya58ajh9qblbw9065zj5hrm3";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ sqlite ]
    ++ [ (if withGtk2 then wxGTK30-gtk2 else wxGTK30-gtk3) ]
    ++ lib.optionals stdenv.isDarwin (with darwin; [ apple_sdk.frameworks.Cocoa ] ++ (with stubs; [ setfile rez derez ]));

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    homepage = "https://utelle.github.io/wxsqlite3/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
    license = [ licenses.lgpl2 ];
  };
}
