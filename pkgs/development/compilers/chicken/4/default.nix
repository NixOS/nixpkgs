{ newScope } :
let
  callPackage = newScope self;

  self = {
    pkgs = self;

    fetchegg = callPackage ./fetchegg { };

    eggDerivation = callPackage ./eggDerivation.nix { };

    chicken = callPackage ./chicken.nix {
      bootstrap-chicken = self.chicken.override { bootstrap-chicken = null; };
    };

    chickenEggs = callPackage ./eggs.nix { };

    egg2nix = callPackage ./egg2nix.nix { };
  };

in self
