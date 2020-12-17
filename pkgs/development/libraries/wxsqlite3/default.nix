{ stdenv
, fetchFromGitHub
, autoreconfHook
, wxGTK
, sqlite
, darwin
}:

stdenv.mkDerivation rec {
  pname = "wxsqlite3";
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    sha256 = "10jlb4p3ahck9apcy2c2mrrjynv4c1dfwwbf1vwd8dl17pgv4kgs";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ wxGTK sqlite ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa darwin.stubs.setfile darwin.stubs.rez darwin.stubs.derez ];

  meta = with stdenv.lib; {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "A C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
    license = [ licenses.lgpl2 ];
  };
}
