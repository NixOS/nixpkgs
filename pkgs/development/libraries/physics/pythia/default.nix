{ stdenv, fetchurl, boost, fastjet, hepmc, lhapdf, rsync, zlib }:

stdenv.mkDerivation rec {
  name = "pythia-${version}";
  version = "8.226";

  src = fetchurl {
    url = "http://home.thep.lu.se/~torbjorn/pythia8/pythia${builtins.replaceStrings ["."] [""] version}.tgz";
    sha256 = "1jfjkq78d1llrrm2k5pgsl92a5z8af9rx3n83rzv28lxrqdjix4g";
  };

  buildInputs = [ boost fastjet hepmc zlib rsync lhapdf ];

  preConfigure = ''
    patchShebangs ./configure
  '';

  configureFlags = [
    "--enable-shared"
    "--with-hepmc2=${hepmc}"
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
