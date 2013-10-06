a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.9.2" a; 
  buildInputs = with a; [
    cmake 
  ];
in
rec {
  src = fetchurl {
    url = "http://www.falconpl.org/project_dl/_official_rel/Falcon-${version}.tar.gz";
    sha256 = "0p32syiz2nc6lmmzi0078g4nzariw5ymdjkmhw6iamc0lkkb9x3i";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doDeploy"];

  doDeploy = a.fullDepEntry (''
    ./build.sh -i -p $out
  '') ["minInit" "addInputs" "doFixInterpreter" "defEnsureDir"];
     
  doFixInterpreter = a.fullDepEntry (''
    sed -e "s@/bin/bash@$shell@" -i build.sh
  '') ["minInit" "doUnpack"];

  name = "falcon-" + version;
  meta = {
    description = "Programming language with macros and syntax at once";
  };
}
