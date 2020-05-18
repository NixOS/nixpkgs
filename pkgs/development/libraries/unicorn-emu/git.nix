{ stdenv, fetchFromGitHub, pkgconfig, python }:

stdenv.mkDerivation rec {
  pname = "unicorn-emulator-git";
  version = "unstable-2020-05-18";

  src = fetchFromGitHub {
    owner = "unicorn-engine";
    repo = "unicorn";
    rev = "2c66acf4ee967e8397dd3d935ff14164fd4b2431";
    sha256 = "1sjsrcw6jj3vjdlg5naydfpdcrzlzxxki3zsqx6slzn0pbfhpcdj";
  };

  configurePhase = '' patchShebangs make.sh '';
  buildPhase = '' ./make.sh '' + stdenv.lib.optionalString stdenv.isDarwin "macos-universal-no";
  installPhase = '' env PREFIX=$out ./make.sh install '';

  nativeBuildInputs = [ pkgconfig python ];
  enableParallelBuilding = true;

  meta = {
    description = "Lightweight multi-platform CPU emulator library";
    homepage    = "http://www.unicorn-engine.org";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.ivar ];
  };
}
