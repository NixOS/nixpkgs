x@{builderDefsPackage
  , readline
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="j";
    version="701_b";
    name="${baseName}-${version}";
    url="http://www.jsoftware.com/download/${baseName}${version}_source.tar.gz";
    hash="1gmjlpxcd647x690c4dxnf8h6ays8ndir6cib70h3zfnkrc34cys";
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
  phaseNames = ["doUnpack" "doBuildJ" "doDeploy"];

  bits = if a.stdenv.system == "i686-linux" then 
    "32"
  else if a.stdenv.system == "x86_64-linux" then
    "64"
  else 
    throw "Oops, unknown system: ${a.stdenv.system}";

  doBuildJ = a.fullDepEntry ''
    sed -i bin/jconfig -e 's@bits=32@bits=${bits}@g; s@readline=0@readline=1@; s@LIBREADLINE=""@LIBREADLINE=" -lreadline "@'
    sed -i bin/build_libj -e 's@>& make.txt@ 2>\&1 | tee make.txt@'

    touch *.c *.h
    sh bin/build_jconsole
    sh bin/build_libj
    sh bin/build_defs
    sh bin/build_tsdll

    sed -i j/bin/profile.ijs -e "s@userx=[.] *'.j'@userx=. '/.j'@; 
        s@bin,'/profilex.ijs'@user,'/profilex.ijs'@ ;
	/install=./ainstall=. install,'/share/j'
	"
  '' ["doUnpack" "addInputs" "minInit"];

  doDeploy = a.fullDepEntry ''
    mkdir -p "$out"
    cp -r j/bin "$out/bin"
    rm "$out/bin/profilex_template.ijs"
    
    mkdir -p "$out/share/j"

    cp -r docs j/addons j/system "$out/share/j"
  '' ["doUnpack" "doBuildJ" "minInit" "defEnsureDir"];
      
  meta = {
    description = "J programming language, an ASCII-based APL successor";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl3Plus;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://jsoftware.com/source.htm";
    };
  };
}) x

