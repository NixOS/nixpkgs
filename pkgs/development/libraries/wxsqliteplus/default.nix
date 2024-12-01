{ lib, stdenv, fetchFromGitHub, wxGTK, wxsqlite3, sqlite, Cocoa, setfile }:

stdenv.mkDerivation rec {
  pname = "wxsqliteplus";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "guanlisheng";
    repo = "wxsqliteplus";
    rev = "v${version}";
    sha256 = "0mgfq813pli56mar7pdxlhwjf5k10j196rs3jd0nc8b6dkzkzlnf";
  };

  postPatch = ''
    sed -i '/WX_CLEAR_ARRAY/s/$/;/' src/{createtable,sqlite3table}.cpp
  '';

  buildInputs = [ wxGTK wxsqlite3 sqlite ] ++ lib.optional stdenv.hostPlatform.isDarwin Cocoa;

  makeFlags = [
    "LDFLAGS=-L${wxsqlite3}/lib"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "SETFILE=${setfile}/bin/SetFile"
  ];

  preBuild = ''
    sed -ie 's|all: $(LIBPREFIX)wxsqlite$(LIBEXT)|all: |g' Makefile
    sed -ie 's|wxsqliteplus$(EXEEXT): $(WXSQLITEPLUS_OBJECTS) $(LIBPREFIX)wxsqlite$(LIBEXT)|wxsqliteplus$(EXEEXT):  $(WXSQLITEPLUS_OBJECTS) |g' Makefile
    sed -ie 's|-lwxsqlite |-lwxcode_${if stdenv.hostPlatform.isDarwin then "osx_cocoau_wxsqlite3-3.2.0" else "gtk3u_wxsqlite3-3.2"} |g' Makefile
  '';

  installPhase = ''
    install -D ${lib.optionalString stdenv.hostPlatform.isDarwin "wxsqliteplus.app/Contents/MacOS/"}wxsqliteplus $out/bin/wxsqliteplus
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv wxsqliteplus.app $out/Applications/
  '';

  meta = with lib; {
    description = "Simple SQLite database browser built with wxWidgets";
    mainProgram = "wxsqliteplus";
    homepage = "https://github.com/guanlisheng/wxsqliteplus";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
