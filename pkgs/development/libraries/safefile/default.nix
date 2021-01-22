{ lib, stdenv, fetchurl, path, runtimeShell }:
stdenv.mkDerivation rec {
  pname = "safefile";
  version = "1.0.5";

  src = fetchurl {
    url = "http://research.cs.wisc.edu/mist/${pname}/releases/${pname}-${version}.tar.gz";
    sha256 = "1y0gikds2nr8jk8smhrl617njk23ymmpxyjb2j1xbj0k82xspv78";
  };

  passthru = {
    updateScript = ''
      #!${runtimeShell}
      cd ${toString ./.}
      ${toString path}/pkgs/build-support/upstream-updater/update-walker.sh default.nix
    '';
  };

  meta = {
    inherit version;
    description = "File open routines to safely open a file when in the presence of an attack";
    license = lib.licenses.asl20 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "https://research.cs.wisc.edu/mist/safefile/";
    updateWalker = true;
  };
}
