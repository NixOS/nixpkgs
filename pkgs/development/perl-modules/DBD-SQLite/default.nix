{ stdenv, fetchurl, buildPerlPackage, DBI, sqlite }:

buildPerlPackage rec {
  name = "DBD-SQLite-${version}";
  version = "1.55_07";

  src = fetchurl {
    url = "https://github.com/DBD-SQLite/DBD-SQLite/archive/${version}.tar.gz";
    sha256 = "0213a31eb7b5afc2d7b3775ca2d1717d07fc7e9ed21ae73b2513a8d54ca222d8";
  };

  propagatedBuildInputs = [ DBI ];
  buildInputs = [ sqlite ];

  patches = [
    # Support building against our own sqlite.
    ./external-sqlite.patch
  ];

  makeMakerFlags = "SQLITE_INC=${sqlite.dev}/include SQLITE_LIB=${sqlite.out}/lib";

  preBuild =
    ''
      substituteInPlace Makefile --replace -L/usr/lib ""
    '';

  postInstall =
    ''
      # Prevent warnings from `strip'.
      chmod -R u+w $out

      # Get rid of a pointless copy of the SQLite sources.
      rm -rf $out/lib/perl5/site_perl/*/*/auto/share
    '';

  # Disabled because the tests can randomly fail due to timeouts
  # (e.g. "database is locked(5) at dbdimp.c line 402 at t/07busy.t").
  #doCheck = false;

  meta = with stdenv.lib; {
    description = "Self Contained SQLite RDBMS in a DBI Driver";
    license = with licenses; [ artistic1 gpl1Plus ];
    platforms = platforms.unix;
  };
}
