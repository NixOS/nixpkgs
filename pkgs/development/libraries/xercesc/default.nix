<<<<<<< HEAD
{ stdenv
, lib
, fetchurl
, curl
}:
=======
{ lib, stdenv, fetchurl }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "xerces-c";
  version = "3.2.4";

  src = fetchurl {
    url = "mirror://apache/xerces/c/3/sources/${pname}-${version}.tar.gz";
    sha256 = "sha256-PY7Bx/lOOP7g5Mpa0eHZ2yPL86ELumJva0r6Le2v5as=";
  };

<<<<<<< HEAD
  buildInputs = [
    curl
  ];

  configureFlags = [
    # Disable SSE2 extensions on platforms for which they are not enabled by default
    "--disable-sse2"
    "--enable-netaccessor-curl"
  ];

=======
  # Disable SSE2 extensions on platforms for which they are not enabled by default
  configureFlags = [ "--disable-sse2" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  enableParallelBuilding = true;

  meta = {
    homepage = "https://xerces.apache.org/xerces-c/";
    description = "Validating XML parser written in a portable subset of C++";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
