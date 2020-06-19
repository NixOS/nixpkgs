{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "unicorn-emulator";
  version = "1.0.2-rc4";

  src = fetchurl {
    url    = "https://github.com/unicorn-engine/unicorn/archive/${version}.tar.gz";
    sha256 = "05w43jq3r97l3c8ggc745ai8m5l93p1b6q6cfp1zwzz6hl5kifiv";
  };

  configurePhase = '' patchShebangs make.sh '';
  buildPhase = '' ./make.sh '' + stdenv.lib.optionalString stdenv.isDarwin "macos-universal-no";
  installPhase = '' env PREFIX=$out ./make.sh install '';

  nativeBuildInputs = [ pkgconfig ];
  enableParallelBuilding = true;

  meta = {
    description = "Lightweight multi-platform CPU emulator library";
    homepage    = "http://www.unicorn-engine.org";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
