{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "unqlite";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "symisc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WLsyGEt7Xe6ZrOGMO7+3TU2sBgDTSmfD1WzD70pcDjo=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://unqlite.org/";
    description = "Self-contained, serverless, zero-conf, transactional NoSQL DB library";
    longDescription = ''
      UnQLite is a in-process software library which implements a
      self-contained, serverless, zero-configuration, transactional NoSQL
      database engine. UnQLite is a document store database similar to MongoDB,
      Redis, CouchDB etc. as well a standard Key/Value store similar to
      BerkeleyDB, LevelDB, etc.

      UnQLite is an embedded NoSQL (Key/Value store and Document-store) database
      engine. Unlike most other NoSQL databases, UnQLite does not have a
      separate server process. UnQLite reads and writes directly to ordinary
      disk files. A complete database with multiple collections, is contained in
      a single disk file. The database file format is cross-platform, you can
      freely copy a database between 32-bit and 64-bit systems or between
      big-endian and little-endian architectures.
    '';
    maintainers = with maintainers; [ AndersonTorres ];
    license = licenses.bsd2;
  };
}
