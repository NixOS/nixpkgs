{ stdenv, fetchFromGitHub, wxGTK, wxsqlite3, sqlite }:

stdenv.mkDerivation rec {
  pname = "wxsqliteplus";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "guanlisheng";
    repo = "wxsqliteplus";
    rev = "v${version}";
    sha256 = "0mgfq813pli56mar7pdxlhwjf5k10j196rs3jd0nc8b6dkzkzlnf";
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
    install -D wxsqliteplus $out/bin/wxsqliteplus
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/guanlisheng/wxsqliteplus";
    description = "A simple SQLite database browser built with wxWidgets";
    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
    license = licenses.gpl2;
  };
}
