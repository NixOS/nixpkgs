a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "v3-5" a; 
  buildInputs = with a; [
    sbcl
  ];
in
rec {
  src = fetchurl {
    url = "http://www.cs.utexas.edu/users/moore/acl2/${version}/distrib/acl2.tar.gz";
    sha256 = "0zmh1njpp7n7azcyjlygr0h0k51d18s1jkj0dr1jn2bh7mpysajk";
    name = "acl2-${version}.tar.gz";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doDeploy" "doBuild"];
  
  makeFlags = ["LISP='${a.sbcl}/bin/sbcl'"];

  installSuffix = "acl2";
  doDeploy = (a.simplyShare installSuffix);
  doBuild = a.fullDepEntry (''
    cd $out/share/${installSuffix}
    make LISP=${a.sbcl}/bin/sbcl
    make LISP=${a.sbcl}/bin/sbcl regression
    mkdir -p "$out/bin"
    cp saved_acl2 "$out/bin/acl2"
  '') ["doDeploy" "addInputs" "defEnsureDir"];
      
  name = "acl2-" + version;
  meta = {
    description = "An interpreter and a prover for a Lisp dialect";
    maintainers = with a.lib.maintainers; 
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
}
