{ stdenv, fetchurl, autoreconfHook, pkgconfig, guile, sqlite }:
stdenv.mkDerivation rec {
  pname = "guile-sqlite3";
  version = "0.1.0";

  src = fetchurl {
    url = "https://notabug.org/${pname}/${pname}/archive/v${version}.tar.gz";
    sha256 = "1s9gmj72vszn999c82vnq0vic7ly4wcg8lz1qcfmhgk9pihcs0bm";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ guile sqlite ];

  meta = with stdenv.lib; {
    description = "Guile bindings to SQLite3";
    homepage = "https://notabug.org/guile-sqlite3/guile-sqlite3";
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.unix;
  };
}
