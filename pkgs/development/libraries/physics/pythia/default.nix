{ lib, stdenv, fetchurl, boost, fastjet, hepmc, lhapdf, rsync, zlib }:

stdenv.mkDerivation rec {
  pname = "pythia";
  version = "8.305";

  src = fetchurl {
    url = "http://home.thep.lu.se/~torbjorn/pythia8/pythia${builtins.replaceStrings ["."] [""] version}.tgz";
    sha256 = "03rpy2bmx67217fh1spfn36x9xrk0igcj56byki77lgj0y5mz21a";
  };

  nativeBuildInputs = [ rsync ];
  buildInputs = [ boost fastjet hepmc zlib lhapdf ];

  preConfigure = ''
    patchShebangs ./configure
  '';

  configureFlags = [
    "--enable-shared"
    "--with-lhapdf6=${lhapdf}"
  ] ++ (if lib.versions.major hepmc.version == "3" then [
    "--with-hepmc3=${hepmc}"
  ] else [
    "--with-hepmc2=${hepmc}"
  ]);

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A program for the generation of high-energy physics events";
    license = licenses.gpl2Only;
    homepage = "http://home.thep.lu.se/~torbjorn/Pythia.html";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
