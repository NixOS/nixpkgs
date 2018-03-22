{ stdenv, fetchurl } :

let 
  major = "3";
  minor = "00";
  version = "${major}.${minor}";

in

stdenv.mkDerivation rec {
  name = "fixedsys-excelsior-${version}";

  src = fetchurl {
    url = http://www.fixedsysexcelsior.com/fonts/FSEX300.ttf;
    sha256 = "6ee0f3573bc5e33e93b616ef6282f49bc0e227a31aa753ac76ed2e3f3d02056d";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp $src $out/share/fonts/truetype/${name}.ttf
  '';

  outputHashMode = "recursive";

  outputHashAlgo = "sha256";

  outputHash = "32d6f07f1ff08c764357f8478892b2ba5ade23427af99759f34a0ba24bcd2e37";
  
  meta = {
    description = "Pan-unicode version of Fixedsys, a classic DOS font.";
    homepage = http://www.fixedsysexcelsior.com/;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.publicDomain;
    maintainers = [ stdenv.lib.maintainers.ninjatrappeur ];
  };
}
