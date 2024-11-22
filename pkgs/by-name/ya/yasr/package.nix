{lib, stdenv,fetchurl}:

stdenv.mkDerivation rec {
  pname = "yasr";

  version = "0.6.9";

  src = fetchurl {
    url = "https://sourceforge.net/projects/yasr/files/yasr/${version}/${pname}-${version}.tar.gz";
    sha256 = "1prv9r9y6jb5ga5578ldiw507fa414m60xhlvjl29278p3x7rwa1";
  };

  patches = [
    ./10_fix_openpty_forkpty_declarations.patch
    ./20_maxpathlen.patch
    ./30_conf.patch
    ./40_dectalk_extended_chars.patch
  ]; # taken from the debian yasr package

  meta = {
    homepage = "https://yasr.sourceforge.net";
    description = "General-purpose console screen reader";
    longDescription = "Yasr is a general-purpose console screen reader for GNU/Linux and other Unix-like operating systems.";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
    maintainers = [ ];
    mainProgram = "yasr";
  };
}
