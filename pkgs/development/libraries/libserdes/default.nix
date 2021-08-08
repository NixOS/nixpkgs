{ stdenv
, lib
, fetchFromGitHub
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
