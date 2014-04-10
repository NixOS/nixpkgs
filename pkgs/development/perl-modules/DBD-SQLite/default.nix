{ stdenv, fetchurl, buildPerlPackage, DBI, sqlite }:

buildPerlPackage rec {
  name = "DBD-SQLite-1.42";

  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/${name}.tar.gz";
    sha256 = "14x9cjsc8dz8ad1nad0bqiq9cbk1rjfb8h5y0rpk3pdl38y6afxb";
  };

  propagatedBuildInputs = [ DBI ];

  makeMakerFlags = "SQLITE_LOCATION=${sqlite}";

  patches = [
    # Support building against our own sqlite.
    ./external-sqlite.patch
  ];

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
  doCheck = false;

  meta.platforms = stdenv.lib.platforms.unix;
}
