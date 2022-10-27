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

  buildInputs = [ wxGTK wxsqlite3 sqlite ] ++ lib.optional stdenv.isDarwin Cocoa;

  makeFlags = [
    "LDFLAGS=-L${wxsqlite3}/lib"
  ] ++ lib.optionals stdenv.isDarwin [
    "SETFILE=${setfile}/bin/SetFile"
  ];

  preBuild = ''
    sed -ie 's|all: $(LIBPREFIX)wxsqlite$(LIBEXT)|all: |g' Makefile
    sed -ie 's|wxsqliteplus$(EXEEXT): $(WXSQLITEPLUS_OBJECTS) $(LIBPREFIX)wxsqlite$(LIBEXT)|wxsqliteplus$(EXEEXT):  $(WXSQLITEPLUS_OBJECTS) |g' Makefile
    sed -ie 's|-lwxsqlite |-lwxcode_${if stdenv.isDarwin then "osx_cocoau_wxsqlite3-3.0.0" else "gtk2u_wxsqlite3-3.0"} |g' Makefile
  '';

  installPhase = ''
    install -D ${lib.optionalString stdenv.isDarwin "wxsqliteplus.app/Contents/MacOS/"}wxsqliteplus $out/bin/wxsqliteplus
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv wxsqliteplus.app $out/Applications/
  '';

  meta = with lib; {
    description = "A simple SQLite database browser built with wxWidgets";
    homepage = "https://github.com/guanlisheng/wxsqliteplus";
    license = licenses.gpl2;
    maintainers = [ maintainers.vrthra ];
    platforms = platforms.unix;
  };
}
