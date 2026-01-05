{
  stdenv,
  lib,
  fetchurl,
  curl,
  icu,
}:

stdenv.mkDerivation rec {
  pname = "xerces-c";
  version = "3.3.0";

  src = fetchurl {
    url = "mirror://apache/xerces/c/3/sources/${pname}-${version}.tar.gz";
    sha256 = "sha256-lVXx0G+CmH+7RliGJwVRV0BBT9NLTbatLtdqLcCNO94=";
  };

  buildInputs = [
    curl
    icu
  ];

  configureFlags = [
    # Disable SSE2 extensions on platforms for which they are not enabled by default
    "--disable-sse2"
    "--enable-netaccessor-curl"
    "--enable-transcoder-icu"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://xerces.apache.org/xerces-c/";
    description = "Validating XML parser written in a portable subset of C++";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
