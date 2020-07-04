{ stdenv, fetchurl, pkgconfig, python }:

stdenv.mkDerivation rec {
  pname = "unicorn-emulator";
  version = "1.0.1";

  src = fetchurl {
    url    = "https://github.com/unicorn-engine/unicorn/archive/${version}.tar.gz";
    sha256 = "0z01apwmvhvdldm372ww9pjfn45awkw3m90c0h4v0nj0ihmlysis";
  };

  configurePhase = '' patchShebangs make.sh '';
  buildPhase = '' ./make.sh '' + stdenv.lib.optionalString stdenv.isDarwin "macos-universal-no";
  installPhase = '' env PREFIX=$out ./make.sh install '';

  nativeBuildInputs = [ pkgconfig python ];
  enableParallelBuilding = true;

  meta = {
    description = "Lightweight multi-platform CPU emulator library";
    homepage    = "http://www.unicorn-engine.org";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
