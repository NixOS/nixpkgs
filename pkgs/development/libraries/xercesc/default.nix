{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "xerces-c";
  version = "3.2.4";

  src = fetchurl {
    url = "mirror://apache/xerces/c/3/sources/${pname}-${version}.tar.gz";
    sha256 = "sha256-PY7Bx/lOOP7g5Mpa0eHZ2yPL86ELumJva0r6Le2v5as=";
  };

  # Disable SSE2 extensions on platforms for which they are not enabled by default
  configureFlags = [ "--disable-sse2" ];
  enableParallelBuilding = true;

  meta = {
    homepage = "https://xerces.apache.org/xerces-c/";
    description = "Validating XML parser written in a portable subset of C++";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
