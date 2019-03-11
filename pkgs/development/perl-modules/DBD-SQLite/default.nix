{ stdenv, fetchurl, buildPerlPackage, perl, DBI, sqlite }:

buildPerlPackage rec {
  name = "DBD-SQLite-1.58";

  src = fetchurl {
    url = mirror://cpan/authors/id/I/IS/ISHIGAKI/DBD-SQLite-1.58.tar.gz;
    sha256 = "0fqx386jgs9mmrknr7smmzapf07izgivza7x08lfm39ks2cxs83i";
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
    rm -rf $out/${perl.libPrefix}/*/*/auto/share
  '';

  meta = with stdenv.lib; {
    description = "Self Contained SQLite RDBMS in a DBI Driver";
    license = with licenses; [ artistic1 gpl1Plus ];
    platforms = platforms.unix;
  };
}
