{ stdenv, lib, fetchFromGitLab, doxygen, glib, libaccounts-glib, pkg-config, qmake, qtbase, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "accounts-qt";
  version = "1.16";

  src = fetchFromGitLab {
    sha256 = "1vmpjvysm0ld8dqnx8msa15hlhrkny02cqycsh4k2azrnijg0xjz";
    rev = "VERSION_${version}";
    repo = "libaccounts-qt";
    owner = "accounts-sso";
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
    homepage = "https://gitlab.com/accounts-sso";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
