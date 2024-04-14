{ lib, stdenv, fetchFromGitHub, automake, autoconf, libtool

# Optional Dependencies
, lz4 ? null, snappy ? null, zlib ? null, bzip2 ? null, db ? null
, gperftools ? null, leveldb ? null
}:

let
  shouldUsePkg = pkg: if pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg then pkg else null;

  optLz4 = shouldUsePkg lz4;
  optSnappy = shouldUsePkg snappy;
  optZlib = shouldUsePkg zlib;
  optBzip2 = shouldUsePkg bzip2;
  optDb = shouldUsePkg db;
  optGperftools = shouldUsePkg gperftools;
  optLeveldb = shouldUsePkg leveldb;
in
stdenv.mkDerivation rec {
  pname = "wiredtiger";
  version = "3.2.1";

  src = fetchFromGitHub {
    repo = "wiredtiger";
    owner = "wiredtiger";
    rev = version;
    sha256 = "04j2zw8b9jym43r682rh4kpdippxx7iw3ry16nxlbybzar9kgk83";
  };

  nativeBuildInputs = [ automake autoconf libtool ];
  buildInputs = [ optLz4 optSnappy optZlib optBzip2 optDb optGperftools optLeveldb ];

  configureFlags = [
    (lib.withFeature   false                   "attach")
    (lib.withFeatureAs true                    "builtins" "")
    (lib.enableFeature (optBzip2 != null)      "bzip2")
    (lib.enableFeature false                   "diagnostic")
    (lib.enableFeature false                   "java")
    (lib.enableFeature (optLeveldb != null)    "leveldb")
    (lib.enableFeature false                   "python")
    (lib.enableFeature (optSnappy != null)     "snappy")
    (lib.enableFeature (optLz4 != null)        "lz4")
    (lib.enableFeature (optGperftools != null) "tcmalloc")
    (lib.enableFeature (optZlib != null)       "zlib")
    (lib.withFeatureAs (optDb != null)         "berkeleydb" optDb)
    (lib.withFeature   false                   "helium")
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    homepage = "http://wiredtiger.com/";
    description = "";
    mainProgram = "wt";
    license = licenses.gpl2;
    platforms = intersectLists platforms.unix platforms.x86_64;
  };
}
