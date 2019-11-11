{ stdenv, fetchFromGitHub, wrapGAppsHook, wxGTK, wxsqlite3, sqlite, glib }:

stdenv.mkDerivation rec {
  pname = "wxsqliteplus";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "guanlisheng";
    repo = "wxsqliteplus";
    rev = "v${version}";
    sha256 = "0mgfq813pli56mar7pdxlhwjf5k10j196rs3jd0nc8b6dkzkzlnf";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = [ wxGTK wxsqlite3 sqlite glib ];

  makeFlags = [
    "LDFLAGS=-L${wxsqlite3}/lib"
  ];

  preBuild = ''
    sed -ie 's|all: $(LIBPREFIX)wxsqlite$(LIBEXT)|all: |g' Makefile
    sed -ie 's|wxsqliteplus$(EXEEXT): $(WXSQLITEPLUS_OBJECTS) $(LIBPREFIX)wxsqlite$(LIBEXT)|wxsqliteplus$(EXEEXT):  $(WXSQLITEPLUS_OBJECTS) |g' Makefile
    sed -ie 's|-lwxsqlite |-lwxcode_gtk3u_wxsqlite3-3.0 |g' Makefile
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
