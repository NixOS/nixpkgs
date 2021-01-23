{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "xerces-c";
  version = "3.2.3";

  src = fetchurl {
    url = "mirror://apache/xerces/c/3/sources/${pname}-${version}.tar.gz";
    sha256 = "0zicsydx6s7carwr7q0csgkg1xncibd6lfp5chg2v2gvn54zr5pv";
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
