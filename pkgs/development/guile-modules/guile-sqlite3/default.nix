{ lib
, stdenv
, fetchFromGitea
, guile
, autoreconfHook
, pkg-config
, texinfo
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "guile-sqlite3";
  version = "0.1.3";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C1a6lMK4O49043coh8EQkTWALrPolitig3eYf+l+HmM=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];
  buildInputs = [
    guile
    sqlite
  ];

  doCheck = true;
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Guile bindings for the SQLite3 database engine";
    homepage = "https://notabug.org/guile-sqlite3/guile-sqlite3";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ miangraham ];
    platforms = guile.meta.platforms;
  };
}
