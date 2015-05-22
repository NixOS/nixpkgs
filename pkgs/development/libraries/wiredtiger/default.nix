{ stdenv, fetchFromGitHub, automake, autoconf, libtool

# Optional Dependencies
, lz4 ? null, snappy ? null, zlib ? null, bzip2 ? null, db ? null
, gperftools ? null, leveldb ? null
}:

with stdenv;
let
  optLz4 = shouldUsePkg lz4;
  optSnappy = shouldUsePkg snappy;
  optZlib = shouldUsePkg zlib;
  optBzip2 = shouldUsePkg bzip2;
  optDb = shouldUsePkg db;
  optGperftools = shouldUsePkg gperftools;
  optLeveldb = shouldUsePkg leveldb;
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "wiredtiger-${version}";
  version = "2.6.0";

  src = fetchFromGitHub {
    repo = "wiredtiger";
    owner = "wiredtiger";
    rev = version;
    sha256 = "0i2r03bpq9xzp5pw7c67kjac5j7mssiawd9id8lqjdbr6c6772cv";
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

  meta = {
    homepage = http://wiredtiger.com/;
    description = "";
    license = licenses.gpl2;
    platforms = intersectLists platforms.unix platforms.x86_64;
    maintainers = with maintainers; [ wkennington ];
  };
}
