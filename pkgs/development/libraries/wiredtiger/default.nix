{ stdenv, fetchFromGitHub, automake, autoconf, libtool

# Optional Dependencies
, lz4 ? null, snappy ? null, zlib ? null, bzip2 ? null, db ? null
, gperftools ? null, leveldb ? null
}:

with stdenv.lib;
let
  mkFlag = trueStr: falseStr: cond: name: val: "--"
    + (if cond then trueStr else falseStr)
    + name
    + optionalString (val != null && cond != false) "=${val}";
  mkEnable = mkFlag "enable-" "disable-";
  mkWith = mkFlag "with-" "without-";

  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (stdenv.lib.meta.platformMatch stdenv.hostPlatform) pkg.meta.platforms then pkg else null;

  optLz4 = shouldUsePkg lz4;
  optSnappy = shouldUsePkg snappy;
  optZlib = shouldUsePkg zlib;
  optBzip2 = shouldUsePkg bzip2;
  optDb = shouldUsePkg db;
  optGperftools = shouldUsePkg gperftools;
  optLeveldb = shouldUsePkg leveldb;
in
stdenv.mkDerivation rec {
  name = "wiredtiger-${version}";
  version = "2.6.1";

  src = fetchFromGitHub {
    repo = "wiredtiger";
    owner = "wiredtiger";
    rev = version;
    sha256 = "1nj319w3hvkq3za2dz9m0p1w683gycdb392v1jb910bhzpsq30pd";
  };

  nativeBuildInputs = [ automake autoconf libtool ];
  buildInputs = [ optLz4 optSnappy optZlib optBzip2 optDb optGperftools optLeveldb ];

  configureFlags = [
    (mkWith   false                   "attach"     null)
    (mkWith   true                    "builtins"   "")
    (mkEnable (optBzip2 != null)      "bzip2"      null)
    (mkEnable false                   "diagnostic" null)
    (mkEnable false                   "java"       null)
    (mkEnable (optLeveldb != null)    "leveldb"    null)
    (mkEnable false                   "python"     null)
    (mkEnable (optSnappy != null)     "snappy"     null)
    (mkEnable (optLz4 != null)        "lz4"        null)
    (mkEnable (optGperftools != null) "tcmalloc"   null)
    (mkEnable (optZlib != null)       "zlib"       null)
    (mkWith   (optDb != null)         "berkeleydb" optDb)
    (mkWith   false                   "helium"     null)
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace api/leveldb/leveldb_wt.h --replace \
      '#include "wiredtiger.h"' \
      ''$'#include "wiredtiger.h"\n#include "pthread.h"'
  '';

  meta = {
    homepage = http://wiredtiger.com/;
    description = "";
    license = licenses.gpl2;
    platforms = intersectLists platforms.unix platforms.x86_64;
    broken = true; # Broken by f689a6d1c6796c4a4f116ffec6c4624379e04bc9.
  };
}
