{ stdenv, fetchurl, bash, cmake }:

stdenv.mkDerivation rec {
  name    = "capstone-${version}";
  version = "3.0.4";

  src = fetchurl {
    url    = "https://github.com/aquynh/capstone/archive/${version}.tar.gz";
    sha256 = "1whl5c8j6vqvz2j6ay2pyszx0jg8d3x8hq66cvgghmjchvsssvax";
  };

  buildInputs = [ cmake ];
  enableParallelBuilding = true;

  meta = {
    description = "Advanced disassembly library";
    homepage    = "http://www.capstone-engine.org";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
