{ stdenv, fetchurl, buildPerlPackage, DBI, sqlite }:

buildPerlPackage rec {
  name = "DBD-SQLite-${version}";
  version = "1.54";

  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/${name}.tar.gz";
    sha256 = "3929a6dbd8d71630f0cb57f85dcef9588cd7ac4c9fa12db79df77b9d3a4d7269";
  };

  propagatedBuildInputs = [ DBI ];
  buildInputs = [ sqlite ];

  patches = [
    # Support building against our own sqlite.
    ./external-sqlite.patch
  ];

  SQLITE_INC = sqlite.dev + "/include";
  SQLITE_LIB = sqlite.out + "/lib";

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
