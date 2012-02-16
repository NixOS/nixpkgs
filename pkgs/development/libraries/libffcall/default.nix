a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "2009-05-27" a; 
  buildInputs = with a; [
    
  ];
in
rec {
  src = a.fetchcvs {
    cvsRoot = ":pserver:anonymous@cvs.savannah.gnu.org:/sources/libffcall";
    module = "ffcall";
    date = version;
    sha256 = "91bcb5a20c85a9ccab45886aae8fdbbcf1f20f995ef898e8bdd2964448daf724";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  doConfigure = a.fullDepEntry (''
    for i in ./configure */configure; do
      cwd="$PWD"
      cd "$(dirname "$i")"; 
      ( test -f Makefile && make distclean ) || true
      ./configure --prefix=$out
      cd "$cwd"
    done
  '') a.doConfigure.deps;

  name = "libffcall-" + version;
  meta = {
    description = "Foreign function call library";
  };
}
