{ stdenv, fetchFromGitHub, sqlite
, wxGTK30-gtk2, wxsqlite3-gtk2 }:

stdenv.mkDerivation rec {
  pname = "wxsqliteplus";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "guanlisheng";
    repo = "wxsqliteplus";
    rev = "v${version}";
    sha256 = "0mgfq813pli56mar7pdxlhwjf5k10j196rs3jd0nc8b6dkzkzlnf";
  };

  buildInputs = [ wxGTK30-gtk2 wxsqlite3-gtk2 sqlite ];

  makeFlags = [
    "LDFLAGS=-L${wxsqlite3-gtk2}/lib"
  ];

  enableParallelBuilding = true;

  preBuild = ''
    sed -ie 's|all: $(LIBPREFIX)wxsqlite$(LIBEXT)|all: |g' Makefile
    sed -ie 's|wxsqliteplus$(EXEEXT): $(WXSQLITEPLUS_OBJECTS) $(LIBPREFIX)wxsqlite$(LIBEXT)|wxsqliteplus$(EXEEXT):  $(WXSQLITEPLUS_OBJECTS) |g' Makefile
    sed -ie 's|-lwxsqlite |-lwxcode_gtk2u_wxsqlite3-3.0 |g' Makefile
  '';

  installPhase = ''
    install -Dm555 -t $out/bin wxsqliteplus
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/guanlisheng/wxsqliteplus";
    description = "A simple SQLite database browser built with wxWidgets";
    license = licenses.gpl2;
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.unix;
  };
}
