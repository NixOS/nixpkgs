/* Generated file. */
args @ { fetchurl, ... }:
rec {
  baseName = "salza2";
  version = "2.1";

  parasites = [ "salza2/test" ];

  description = "Create compressed data in the ZLIB, DEFLATE, or GZIP
  data formats";

  deps = [ args."chipz" args."flexi-streams" args."parachute" args."trivial-gray-streams" ];

  src = fetchurl {
    url = "http://beta.quicklisp.org/archive/salza2/2021-10-20/salza2-2.1.tgz";
    sha256 = "0ymx3bm2a9a3fwxbvcyzfy0cdfl5y0csyw5cybxy0whkwipgra0x";
  };

  packageName = "salza2";

  asdFilesToKeep = ["salza2.asd"];
  overrides = x: x;
}
/* (SYSTEM salza2 DESCRIPTION
    Create compressed data in the ZLIB, DEFLATE, or GZIP
  data formats
    SHA256 0ymx3bm2a9a3fwxbvcyzfy0cdfl5y0csyw5cybxy0whkwipgra0x URL
    http://beta.quicklisp.org/archive/salza2/2021-10-20/salza2-2.1.tgz MD5
    867f3e0543a7e34d1be802062cf4893d NAME salza2 FILENAME salza2 DEPS
    ((NAME chipz FILENAME chipz) (NAME flexi-streams FILENAME flexi-streams)
     (NAME parachute FILENAME parachute)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (chipz flexi-streams parachute trivial-gray-streams) VERSION
    2.1 SIBLINGS NIL PARASITES (salza2/test)) */
