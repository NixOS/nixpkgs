{ lib, stdenv
, build2
, fetchurl
, libodb
, sqlite
, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? !enableShared
}:
stdenv.mkDerivation rec {
  pname = "libodb-sqlite";
  version = "2.5.0-b.19";

  outputs = [ "out" "dev" "doc" ];

  src = fetchurl {
    url = "https://pkg.cppget.org/1/beta/odb/libodb-sqlite-${version}.tar.gz";
    sha256 = "9443653bfc31d02d0d723f18072f6b04083d090e6580844e33c1e769db122494";
  };

  nativeBuildInputs = [
    build2
  ];
  buildInputs = [
    libodb
  ];
  propagatedBuildInputs = [
    sqlite
  ];

  build2ConfigureFlags = [
    "config.bin.lib=${build2.configSharedStatic enableShared enableStatic}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "SQLite ODB runtime library";
    longDescription = ''
      ODB is an object-relational mapping (ORM) system for C++. It provides
      tools, APIs, and library support that allow you to persist C++ objects
      to a relational database (RDBMS) without having to deal with tables,
      columns, or SQL and without manually writing any of the mapping code.
      For more information see:

      http://www.codesynthesis.com/products/odb/

      This package contains the SQLite ODB runtime library. Every application
      that includes code generated for the SQLite database will need to link
      to this library.
    '';
    homepage = "https://www.codesynthesis.com/products/odb/";
    changelog = "https://git.codesynthesis.com/cgit/odb/libodb-sqlite/tree/NEWS";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ r-burns ];
  };
}
