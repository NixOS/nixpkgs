{ stdenv, fetchurl }:

let
  fetch = { version, src ? builtins.getAttr stdenv.system sources, sources ? null }:
  {
    inherit version src;
  };

in {

  ### VERSION 9.6 

  v9_6 = fetch {
    version = "9.6";

    src = fetchurl{
      url = "http://geant4.cern.ch/support/source/geant4.9.6.tar.gz";
      sha256 = "3b1caf87664ef35cab25563b2911653701e98c75a9bd6c64f364d1a1213247e5";
    };  
  };  

  v9_6_1 = fetch {
    version = "9.6.1";

    src = fetchurl{
      url = "http://geant4.cern.ch/support/source/geant4.9.6.p01.tar.gz";
      sha256 = "575c45029afc2405d70c38e6dcfd1a752564b2540f33a922230039be81c8e4b6";
    };  
  };  

  v9_6_2 = fetch {
    version = "9.6.2";

    src = fetchurl{
      url = "http://geant4.cern.ch/support/source/geant4.9.6.p02.tar.gz";
      sha256 = "cf5df83b7e2c99e6729449b32d3ecb0727b4692317426b66fc7fd41951c7351f";
    };  
  };  

  v9_6_3 = fetch {
    version = "9.6.3";

    src = fetchurl{
      url = "http://geant4.cern.ch/support/source/geant4.9.6.p03.tar.gz";
      sha256 = "3a7e969039e8992716b3bc33b44cbdbff9c8d5850385f1a02fdd756a4fa6305c";
    };  
  };  

  ### Version 10.0

  v10_0 = fetch {
    version = "10.0";

    src = fetchurl{
      url = "http://geant4.cern.ch/support/source/geant4.10.00.tar.gz";
      sha256 = "ffec1714b03748b6d691eb0b91906f4c74422c1ad1f8afa918e03be421af8a17";
    };  
  };  

  v10_0_1 = fetch {
    version = "10.0.1";

    src = fetchurl{
      url = "http://geant4.cern.ch/support/source/geant4.10.00.p01.tar.gz";
      sha256 = "09c431ff3ef81034282c46501cea01046d4a20438c2ea2a7339576e1ecf26ba0";
    };  
  };  

  v10_0_2 = fetch {
    version = "10.0.2";

    src = fetchurl{
      url = "http://geant4.cern.ch/support/source/geant4.10.00.p02.tar.gz";
      sha256 = "9d615200901f1a5760970e8f5970625ea146253e4f7c5ad9df2a9cf84549e848";
    };  
  };
}

