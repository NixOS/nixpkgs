{ stdenv, lib, fetchFromGitHub
, mcpp, bzip2, expat, openssl, db5
, darwin, libiconv, Security
, zeroc-ice # to share meta
, cpp11 ? false
}:

stdenv.mkDerivation rec {
  pname = "zeroc-ice";
  version = "3.6.5";

  src = fetchFromGitHub {
    owner = "zeroc-ice";
    repo = "ice";
    rev = "v${version}";
    sha256 = "073h7v1f2sw77cr1a6xxa5l9j547pz24sxa9qdjc4zki0ivcnq15";
  };

  buildInputs = [ mcpp bzip2 expat openssl db5 ]
    ++ lib.optionals stdenv.isDarwin [ darwin.cctools libiconv Security ];

  postUnpack = ''
    sourceRoot=$sourceRoot/cpp
  '';

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace config/Make.rules.Darwin \
        --replace xcrun ""
  '';

  patches = [
    # Fixes compilation warning about uninitialied variables (in test code)
    ./uninitialized-variable-warning.patch
  ];

  preBuild = ''
    makeFlagsArray+=(
      "prefix=$out"
      "OPTIMIZE=yes"
      "USR_DIR_INSTALL=yes"
      "CONFIGS=${if cpp11 then "cpp11-shared" else "shared"}"
      "SKIP=slice2py" # provided by a separate package
    )
  '';

  # cannot find -lIceXML (linking bin/transformdb)
  enableParallelBuilding = false;

  outputs = [ "out" "bin" "dev" ];

  postInstall = ''
    mkdir -p $bin $dev/share
    mv $out/bin $bin
    mv $out/share/Ice-* $dev/share/ice
    rm -rf $out/share/slice
  '';

  inherit (zeroc-ice) meta;
}
