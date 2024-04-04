{ stdenv, lib, fetchFromGitLab, doxygen, glib, libaccounts-glib, pkg-config, qmake, qtbase, wrapQtAppsHook }:

stdenv.mkDerivation {
  pname = "accounts-qt";
  version = "1.16-unstable-2023-11-24";

  # pinned to fork with Qt6 support
  src = fetchFromGitLab {
    owner = "nicolasfella";
    repo = "libaccounts-qt";
    rev = "18557f7def9af8f4a9e0e93e9f575ae11e5066aa";
    hash = "sha256-8FGZmg2ljSh1DYZfklMTrWN7Sdlk/Atw0qfpbb+GaBc=";
  };

  propagatedBuildInputs = [ glib libaccounts-glib ];
  buildInputs = [ qtbase ];
  nativeBuildInputs = [ doxygen pkg-config qmake wrapQtAppsHook ];

  # remove forbidden references to /build
  preFixup = ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$out"/bin/*
  '';

  meta = with lib; {
    description = "Qt library for accessing the online accounts database";
    mainProgram = "accountstest";
    homepage = "https://gitlab.com/accounts-sso";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
