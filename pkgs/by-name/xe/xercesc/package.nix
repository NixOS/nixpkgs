{ stdenv
, lib
, fetchurl
, curl
}:

stdenv.mkDerivation rec {
  pname = "xerces-c";
  version = "3.2.5";

  src = fetchurl {
    url = "mirror://apache/xerces/c/3/sources/${pname}-${version}.tar.gz";
    sha256 = "sha256-VFz8zmxOdVIHvR8n4xkkHlDjfAwnJQ8RzaEWAY8e8PU=";
  };

  buildInputs = [
    curl
  ];

  configureFlags = [
    # Disable SSE2 extensions on platforms for which they are not enabled by default
    "--disable-sse2"
    "--enable-netaccessor-curl"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://xerces.apache.org/xerces-c/";
    description = "Validating XML parser written in a portable subset of C++";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
