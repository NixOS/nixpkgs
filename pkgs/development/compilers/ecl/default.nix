{builderDefsPackage
  , gmp, mpfr, libffi
  , ...} @ x:
builderDefsPackage (a :  
let 
  propagatedBuildInputs = with a; [
    gmp mpfr
  ];
  buildInputs = [ gmp libffi mpfr ];
in
rec {
  mainVersion = "12.7";
  revision = "1";
  version = "${mainVersion}.${revision}";

  name = "ecl-${version}";

  src = a.fetchurl {
    url = "mirror://sourceforge/project/ecls/ecls/${mainVersion}/${name}.tar.gz";
    sha256 = "0k8ww142g3bybvvnlijqsbidl8clbs1pb4ympk2ds07z5swvy2ap";
  };

  inherit buildInputs propagatedBuildInputs;
  configureFlags = [
    "--enable-threads"
    ]
    ++
    (a.lib.optional (! (a.lib.attrByPath ["noUnicode"] false a)) 
      "--enable-unicode")
    ;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall" "fixEclConfig"];

  fixEclConfig = a.fullDepEntry ''
    sed -e 's/@[-a-zA-Z_]*@//g' -i $out/bin/ecl-config
  '' ["minInit"];
      
  meta = {
    description = "A Lisp implementation aiming to be small and fast";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };
}) x
