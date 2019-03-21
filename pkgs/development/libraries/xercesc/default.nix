{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "xerces-c-${version}";
  version = "3.2.2";

  src = fetchurl {
    url = "mirror://apache/xerces/c/3/sources/${name}.tar.gz";
    sha256 = "04q4c460wqzyzmprjm22igcm1d52xr20ajxnhr33nv95mbw92qfx";
  };

  # Disable SSE2 extensions on platforms for which they are not enabled by default
  configureFlags = [ "--disable-sse2" ];
  enableParallelBuilding = true;

  meta = {
    homepage = https://xerces.apache.org/xerces-c/;
    description = "Validating XML parser written in a portable subset of C++";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
