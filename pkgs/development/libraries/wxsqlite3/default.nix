{ stdenv, fetchFromGitHub, wxGTK, sqlite }:

stdenv.mkDerivation rec {
  name = "wxsqlite3-${version}";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    sha1 = "bb8p58g88nkdcsj3h4acx7h925n2cy9g";
  };

  buildInputs = [ wxGTK sqlite ];

  meta = with stdenv.lib; {
    homepage = http://utelle.github.io/wxsqlite3/ ;
    description = "A C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
    license = [ licenses.lgpl2 ];
  };
}
