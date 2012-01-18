x@{builderDefsPackage
  , flex, bison
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="tcp-wrappers";
    version="7.6";
    name="${baseName}-${version}";
    url="http://ftp.porcupine.org/pub/security/tcp_wrappers_${version}.tar.gz";
    hash="0p9ilj4v96q32klavx0phw9va21fjp8vpk11nbh6v2ppxnnxfhwm";
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
  phaseNames = ["setVars" "doUnpack" "fixMakefile" "doPatch" 
    "doMake" "doDeploy"];

  patches = [./have-strerror.patch ./trivial-fixes.patch];

  makeFlags = [
    "REAL_DAEMON_DIR=$out/bin"
    "STYLE='\"-DHAVE_STRERROR -DSYS_ERRLIST_DEFINED\"'"
    "generic"
  ];

  setVars = a.noDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lnsl"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fPIC"
  '';

  fixMakefile = a.fullDepEntry ''
    chmod u+w Makefile
    echo 'libwrap.so: $(LIB_OBJ)' >> Makefile
    echo '	ld $(LIB_OBJ) --shared -o libwrap.so' >> Makefile
  '' ["minInit"];

  doDeploy = a.fullDepEntry ''
    mkdir -p "$out"/{sbin,lib}
    make libwrap.so
    cp libwrap.{a,so} "$out/lib"
    find . -perm +111 -a ! -name '*.*' -exec cp '{}' "$out/sbin" ';'
  '' ["defEnsureDir" "minInit"];
      
  meta = {
    description = "Network logging TCP wrappers";
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
      downloadPage = "http://ftp.porcupine.org/pub/security/index.html";
    };
  };
}) x
