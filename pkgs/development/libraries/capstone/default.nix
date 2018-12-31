{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  name    = "capstone-${version}";
  version = "4.0";

  src = fetchurl {
    url    = "https://github.com/aquynh/capstone/archive/${version}.tar.gz";
    sha256 = "0yp6y5m3v674i2pq6s804ikvz43gzgsjwq1maqhmj3b730b4dii6";
  };

  configurePhase = '' patchShebangs make.sh '';
  buildPhase = '' ./make.sh '';
  installPhase = '' env PREFIX=$out ./make.sh install '';
  
  nativeBuildInputs = [
    pkgconfig
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Advanced disassembly library";
    homepage    = "http://www.capstone-engine.org";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
