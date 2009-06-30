a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "1.8.1" a; 
  buildInputs = with a; [
    perl
  ];
in
rec {
  src = fetchurl {
    url = "http://files.randombit.net/botan/Botan-${version}.tbz";
    sha256 = "1lgqkg7q0qpzh647zmzay149myrjihcx4jp3rrz6gw17rgn11v98";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];

  configureCommand = "perl ./configure.pl";
  
  name = "botan-" + version;
  meta = {
    description = "Cryptographic algorithms library";
  };
}
