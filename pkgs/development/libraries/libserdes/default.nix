{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, perl
, boost
, rdkafka
, jansson
, curl
, avro-c
, avro-cpp }:

stdenv.mkDerivation rec {
  pname = "libserdes";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = pname;
    rev = "v${version}";
    sha256 = "194ras18xw5fcnjgg1isnb24ydx9040ndciniwcbdb7w7wd901gc";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ perl ];

  buildInputs = [ boost rdkafka jansson curl avro-c avro-cpp ];

  makeFlags = [ "GEN_PKG_CONFIG=y" ];

  patches = [
    # Fix compatibility with Avro master branch
    (fetchpatch {
      url = "https://github.com/confluentinc/libserdes/commit/d7a355e712ab63ec77f6722fb5a9e8056e7416a2.patch";
      sha256 = "14bdx075n4lxah63kp7phld9xqlz3pzs03yf3wbq4nmkgwac10dh";
    })
  ];

  postPatch = ''
    patchShebangs configure lds-gen.pl
  '';

  # Has a configure script but it’s not Autoconf so steal some bits from multiple-outputs.sh:
  setOutputFlags = false;

  preConfigure = ''
    configureFlagsArray+=(
      "--libdir=''${!outputLib}/lib"
      "--includedir=''${!outputInclude}/include"
    )
  '';

  preInstall = ''
    installFlagsArray+=("pkgconfigdir=''${!outputDev}/lib/pkgconfig")
  '';

  # Header files get installed with executable bit for some reason; get rid of it.
  postInstall = ''
    chmod -x ''${!outputInclude}/include/libserdes/*.h
  '';

  meta = with lib; {
    description = "A schema-based serializer/deserializer C/C++ library with support for Avro and the Confluent Platform Schema Registry";
    homepage = "https://github.com/confluentinc/libserdes";
    license = licenses.asl20;
    maintainers = with maintainers; [ liff ];
    platforms = platforms.all;
  };
}
