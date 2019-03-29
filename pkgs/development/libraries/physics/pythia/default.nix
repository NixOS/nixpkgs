{ stdenv, fetchurl, boost, fastjet, hepmc, lhapdf, rsync, zlib }:

stdenv.mkDerivation rec {
  name = "pythia-${version}";
  version = "8.240";

  src = fetchurl {
    url = "http://home.thep.lu.se/~torbjorn/pythia8/pythia${builtins.replaceStrings ["."] [""] version}.tgz";
    sha256 = "13cd86030j1f00n4xw30g26cgir3a5lsn9n0z13dh1vprbc9ax6j";
  };

  buildInputs = [ boost fastjet hepmc zlib rsync lhapdf ];

  preConfigure = ''
    patchShebangs ./configure
  '';

  configureFlags = [
    "--enable-shared"
    "--with-hepmc2=${hepmc}"
    "--with-lhapdf6=${lhapdf}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A program for the generation of high-energy physics events";
    license     = stdenv.lib.licenses.gpl2;
    homepage    = http://home.thep.lu.se/~torbjorn/Pythia.html;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ veprbl ];
  };
}
