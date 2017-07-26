{ stdenv, fetchFromGitHub, wxGTK, sqlite
, darwin }:

stdenv.mkDerivation rec {
  name = "wxsqlite3-${version}";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    sha1 = "bb8p58g88nkdcsj3h4acx7h925n2cy9g";
  };

  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    cp build28/Info.plist.in build28/wxmac.icns build/
  '';

  buildInputs = [ wxGTK sqlite ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa darwin.stubs.setfile darwin.stubs.rez darwin.stubs.derez ];

  meta = with stdenv.lib; {
    homepage = http://utelle.github.io/wxsqlite3/ ;
    description = "A C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
    license = [ licenses.lgpl2 ];
  };
}
