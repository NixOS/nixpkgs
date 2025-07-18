{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  tcl,
  tk,
  libGL,
}:

stdenv.mkDerivation {
  pname = "tkgl";
  version = "1.2.1-unstable-2025-06-01";

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "TkGL";
    rev = "45bf16e6c28a070c70fc9a0eb8c47a0b6ff8a2e3";
    hash = "sha256-AA5LZGhMTWmTZqI/wtycUYLsUe9BwO3voGMS7vGlCM0=";
  };

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace-fail "install: all install-binaries install-libraries install-doc" \
                 "install: all install-binaries"
    substituteInPlace configure.ac \
      --replace-fail "-arch x86_64 -arch arm64" ""
  '';

  configureFlags = [
    "--with-tcl=${lib.getLib tcl}/lib"
    "--with-tclinclude=${lib.getDev tcl}/include"
    "--with-tk=${lib.getLib tk}/lib"
    "--with-tkinclude=${lib.getDev tk}/include"
    "--libdir=${placeholder "out"}/lib"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    tcl
    tk
    libGL
  ];

  meta = {
    description = "OpenGL drawing surface for Tk 8 and 9";
    homepage = "https://github.com/3-manifolds/TkGL";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ noiioiu ];
  };
}
