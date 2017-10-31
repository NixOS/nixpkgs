{ stdenv, fetchFromGitHub, wxGTK, wxsqlite3, sqlite }:

stdenv.mkDerivation rec {
  name = "wxsqliteplus-${version}";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "guanlisheng";
    repo = "wxsqliteplus";
    rev = "v${version}";
    sha1 = "yr9ysviv4hbrxn900z1wz8j32frimvx1";
  };

  buildInputs = [ wxGTK wxsqlite3 sqlite ];

  makeFlags = [
    "LDFLAGS=-L${wxsqlite3}/lib"
  ];

  preBuild = ''
    sed -ie 's|all: $(LIBPREFIX)wxsqlite$(LIBEXT)|all: |g' Makefile
    sed -ie 's|wxsqliteplus$(EXEEXT): $(WXSQLITEPLUS_OBJECTS) $(LIBPREFIX)wxsqlite$(LIBEXT)|wxsqliteplus$(EXEEXT):  $(WXSQLITEPLUS_OBJECTS) |g' Makefile
    sed -ie 's|-lwxsqlite |-lwxcode_gtk2u_wxsqlite3-3.0 |g' Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp wxsqliteplus $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = http://guanlisheng.com/;
    description = "A simple SQLite database browser built with wxWidgets";
    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
    license = licenses.gpl2;
  };
}
