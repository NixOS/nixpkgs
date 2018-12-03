{ stdenv, fetchurl, path }:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "safefile";
  version = "1.0.5";

  src = fetchurl {
    url = "http://research.cs.wisc.edu/mist/${pname}/releases/${name}.tar.gz";
    sha256 = "1y0gikds2nr8jk8smhrl617njk23ymmpxyjb2j1xbj0k82xspv78";
  };

  buildInputs = [];

  passthru = {
    updateScript = ''
      #!${stdenv.shell}
      cd ${toString ./.}
      ${toString path}/pkgs/build-support/upstream-updater/update-walker.sh default.nix
    '';
  };

  meta = {
    inherit version;
    description = "File open routines to safely open a file when in the presence of an attack";
    license = stdenv.lib.licenses.asl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://research.cs.wisc.edu/mist/safefile/;
    updateWalker = true;
  };
}
