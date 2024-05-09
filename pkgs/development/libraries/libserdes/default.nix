{ stdenv
, lib
, fetchFromGitHub
, perl
, which
, boost
, rdkafka
, jansson
, curl
, avro-c
, avro-cpp
, nix-update-script }:

stdenv.mkDerivation rec {
  pname = "libserdes";
  version = "7.6.1";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rg4SWa9nIDT6JrnnCDwdiFE1cvpUn0HWHn+bPkXMHQ4=";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ perl which ];

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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A schema-based serializer/deserializer C/C++ library with support for Avro and the Confluent Platform Schema Registry";
    homepage = "https://github.com/confluentinc/libserdes";
    license = licenses.asl20;
    maintainers = with maintainers; [ liff ];
    platforms = platforms.all;
  };
}
