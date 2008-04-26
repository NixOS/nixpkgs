args : with args; 
rec {
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/l/lmodern/lmodern_0.92.orig.tar.gz;
    sha256 = "0ak3n7fsi2va94gsn0pfmyby2b4g7wz9h5a0prpbx24ax1xwinls";
  };

  buildInputs = [];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doCopy"];

  doCopy = FullDepEntry(''
    ensureDir $out/share/texmf/fonts/enc 
    ensureDir $out/share/texmf/fonts/map 
    ensureDir $out/share/texmf/fonts/type1/public/lm 
    ensureDir $out/share/texmf/dvips/lm 
    ensureDir $out/share/texmf/dvipdfm/config

    cp -r ./* $out/share/texmf/

    cp dvips/lm/*.enc $out/share/texmf/fonts/enc
    cp dvips/lm/*.map $out/share/texmf/fonts/map
    cp dvips/lm/*.map $out/share/texmf/dvipdfm/config
  '') ["minInit" "defEnsureDir" "doUnpack"];

  name = "lmodern-" + version;
  meta = {
    description = "Latin Modern font";
  };
}
