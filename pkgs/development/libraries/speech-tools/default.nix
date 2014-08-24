x@{builderDefsPackage
  , gawk, alsaLib, ncurses
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="speech_tools";
    version="2.1";
    name="${baseName}-${version}";
    url="http://www.festvox.org/packed/festival/${version}/${name}-release.tar.gz";
    hash="1s9bkfgdgyas8v2cr7x3dg0ck1xf9mn1q6a73gwy524sjb6nfqgz";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doUnpack" "killUsrBin" "doConfigure" "doMakeInstall" "doDeploy" "fixPaths"];
      
  killUsrBin = a.fullDepEntry ''
    sed -e s@/usr/bin/@@g -i $( grep -rl '/usr/bin/' . )
    sed -re 's@/bin/(rm|printf|uname)@\1@g' -i $( grep -rl '/bin/' . )
  '' ["minInit" "doUnpack"];

  doDeploy = a.fullDepEntry ''
    mkdir -p "$out"/{bin,lib}
    for d in bin lib; do
      for i in ./$d/*; do
        test "$(basename "$i")" = "Makefile" ||
          cp -r "$(readlink -f $i)" "$out/$d"
      done
    done
  '' ["doMakeInstall" "defEnsureDir"];

  fixPaths = a.doPatchShebangs "$out/bin";

  meta = {
    broken = true;
    description = "Text-to-speech engine";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "free-noncopyleft";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.festvox.org/packed/festival/";
    };
  };
}) x

