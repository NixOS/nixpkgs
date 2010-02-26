a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
  ];
  propagatedBuildInputs = with a; [
    gmp mpfr
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs propagatedBuildInputs;
  configureFlags = [
    "--enable-threads"
    ]
    ++
    (a.lib.optional (! a.noUnicode) "--enable-unicode")
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
}
