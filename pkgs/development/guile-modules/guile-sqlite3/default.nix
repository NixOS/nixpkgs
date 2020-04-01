{ stdenv, fetchurl, guile, sqlite
, autoreconfHook, pkg-config, texinfo
}:

stdenv.mkDerivation rec {
  pname = "guile-sqlite3";
  version = "0.1.0";

  src = fetchurl {
    url = "https://notabug.org/guile-sqlite3/${pname}/archive/v${version}.tar.gz";
    sha256 = "1s9gmj72vszn999c82vnq0vic7ly4wcg8lz1qcfmhgk9pihcs0bm";
  };

  postConfigure = ''
    sed -i '/moddir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/godir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config texinfo ];
  buildInputs = [ guile ];
  propagatedBuildInputs = [ sqlite ];

  meta = with stdenv.lib; {
    description = "Bindings to Sqlite3 for GNU Guile";
    homepage = "https://notabug.org/guile-gcrypt/guile-gcrypt";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bqv ];
    platforms = platforms.all;
  };
}

