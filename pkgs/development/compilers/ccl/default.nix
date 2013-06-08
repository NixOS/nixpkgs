a :  
let 
  buildInputs = with a; [
    
  ];
in
rec {
  version = "1.8";
  name = "ccl-${version}";

  /* There are also MacOS and FreeBSD and Windows versions */
  src = a.fetchurl {
    url = "ftp://ftp.clozure.com/pub/release/${version}/${name}-linuxx86.tar.gz";
    sha256 = "1dgg6a8i2csa6xidsq66hbw7zx62gm2178hpkp88yyzgxylszp01";
  };
  
  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doUnpack" "doPatchElf" "doCopy"];

  doCopy = a.fullDepEntry ''
    mkdir -p "$out/share"
    cp -r . "$out/share/ccl-installation"

    mkdir -p "$out/bin"
    for i in $(find . -maxdepth 1 -type f -perm +111); do
      echo -e '#! /bin/sh\n'"$out/share/ccl-installation/$(basename "$i")"'"$@"\n' > "$out"/bin/"$(basename "$i")"
      chmod a+x "$out"/bin/"$(basename "$i")"
    done
  '' ["minInit" "doUnpack" "defEnsureDir"];

  doPatchElf = a.fullDepEntry ''
    patchelfFile="$(type -P patchelf)"
    goodInterp="$(patchelf --print-interpreter "$patchelfFile")"
    find . -type f -perm +111 -exec  patchelf --set-interpreter "$goodInterp" '{}' ';'
  '' ["minInit" "doUnpack"];
      
  meta = {
    description = "Clozure Common Lisp";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };
}

