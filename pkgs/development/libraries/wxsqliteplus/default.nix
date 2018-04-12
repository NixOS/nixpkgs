{ stdenv, fetchFromGitHub, wxGTK_3, wxsqlite3, sqlite }:

stdenv.mkDerivation rec {
  name = "wxsqliteplus-${version}";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "guanlisheng";
    repo = "wxsqliteplus";
    rev = "v${version}";
    sha1 = "yr9ysviv4hbrxn900z1wz8j32frimvx1";
  };

  buildInputs = [ wxGTK_3 wxsqlite3 sqlite ];

  makeFlags = [
    "LDFLAGS=-L${wxsqlite3}/lib"
  ];

  preBuild = ''
    libname="$(basename ${wxsqlite3}/lib/libwxcode_gtk?u_wxsqlite3-*.so)"
    libname="''${libname#lib}"
    libname="''${libname%.so}"
    sed -ie 's|all: $(LIBPREFIX)wxsqlite$(LIBEXT)|all: |g' Makefile
    sed -ie 's|wxsqliteplus$(EXEEXT): $(WXSQLITEPLUS_OBJECTS) $(LIBPREFIX)wxsqlite$(LIBEXT)|wxsqliteplus$(EXEEXT):  $(WXSQLITEPLUS_OBJECTS) |g' Makefile
    sed -ie "s|-lwxsqlite |-l$libname |g" Makefile
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
