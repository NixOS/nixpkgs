{ stdenv, fetchurl, buildPerlPackage, DBI, sqlite }:

buildPerlPackage rec {
  name = "DBD-SQLite-1.57_01";

  src = fetchurl {
    url = mirror://cpan/authors/id/I/IS/ISHIGAKI/DBD-SQLite-1.57_01.tar.gz;
    sha256 = "1111cwlqkf4837y8mf8sag2cma82r059iy0869y2bz4bz88v2zzs";
  };

  propagatedBuildInputs = [ DBI ];
  buildInputs = [ sqlite ];

  patches = [
    # Support building against our own sqlite.
    ./external-sqlite.patch
  ];

  makeMakerFlags = "SQLITE_INC=${sqlite.dev}/include SQLITE_LIB=${sqlite.out}/lib";

  postInstall = ''
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
