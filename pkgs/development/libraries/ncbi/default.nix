a :  
let 
  fetchurl = a.fetchurl;

  version = "20090809"; 
  buildInputs = with a; [
    tcsh libX11 libXaw lesstif xproto mesa libXt 
    libSM libICE libXmu libXext 
  ];
in
rec {
  src = fetchurl {
    url = "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/old/${version}/ncbi.tar.gz";
    sha256 = "05bbnqk6ffvhi556fsabcippzq2zrkynbk09qblzvfzip9hlk1qc";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preBuild" "build" "deploy"];

  preBuild = a.fullDepEntry (''
    sed -e 's@#!/bin/csh@#! ${a.tcsh}/bin/csh@' -i $(fgrep '#!/bin/csh' -rl build make)
    sed -e '/set path/d' -i make/ln-if-absent
    sed -e 's@/usr/include @${a.lesstif}/include ${a.mesa}/include @' -i make/makedis.csh
    sed -e 's@/usr/[a-zA-Z0-9]*/include @@g; s@/usr/include/[a-zA-Z0-9/] @@g' -i make/makedis.csh 
    cd ..
  '') ["doUnpack" "minInit"];

  build = a.fullDepEntry (''
    ./ncbi/make/makedis.csh
  '') ["preBuild" "addInputs"];

  deploy = a.fullDepEntry (''
    mkdir -p $out/bin $out/lib $out/include $out/source $out/share/${name}/build-snapshot
    cd ncbi/build
    cp *.o *.so $out/lib
    cp -r . $out/share/${name}/build-snapshot
    cp ../make/makedis.csh $out/share/${name}/build-snapshot
    cp *.h $out/include 
    cp *.c *.h $out/source
    find . -perm +111 -a '(' '(' ! -name '*.*' ')' -o '(' -name '*.REAL' ')' ')' -exec cp '{}' $out/bin ';'
  '') ["defEnsureDir" "build" "minInit"];
      
  name = "NCBI-Toolbox-" + version;
  meta = {
    description = "NCBI general-purpose portable toolkit";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    #platforms = a.lib.platforms.linux ;
  };
}
