x@{builderDefsPackage
  , jdk /* only used in bootstrap */
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="picolisp";
    tarballBaseName="picoLisp";
    version="3.0.5";
    name="${baseName}-${version}";
    tarballName="${tarballBaseName}-${version}";
    extension="tgz";
    url="http://www.software-lab.de/${tarballName}.${extension}";
    hash="07w2aygllkmnfcnby3dy88n9giqsas35s77rp2lr2ll5yy2hkc0x";
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
  phaseNames = ["doMake" "doDeploy"];

  goSrcDir = if a.stdenv.system == "x86_64-linux" then 
    "cd src64" else "cd src";
  makeFlags = [''PREFIX=$out''];

  doDeploy = a.fullDepEntry (''
    cd ..

    sed -e "s@/usr/@$out/@g" -i bin/pil

    mkdir -p "$out/share/picolisp" "$out/lib" "$out/bin"
    cp -r . "$out/share/picolisp/build-dir"
    ln -s "$out/share/picolisp/build-dir" "$out/lib/picolisp"
    ln -s "$out/lib/picolisp/bin/picolisp" "$out/bin/picolisp"
  '') ["minInit" "defEnsureDir" "doMake"];
      
  meta = {
    description = "An interpreter for a small Lisp dialect with builtin DB";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.mit;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.software-lab.de/down.html";
    };
  };
}) x

