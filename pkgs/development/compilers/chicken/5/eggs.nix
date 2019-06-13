{ pkgs, stdenv }:
rec {
  inherit (pkgs) eggDerivation fetchegg;

  args = eggDerivation {
    name = "args-1.6.0";

    src = fetchegg {
      name = "args";
      version = "1.6.0";
      sha256 = "1y9sznh4kxqxvhd8k44bjx0s7xspp52sx4bn8i8i0f8lwch6r2g4";
    };

    buildInputs = [
      srfi-1
      srfi-13
      srfi-37
    ];
  };

  matchable = eggDerivation {
    name = "matchable-1.0";

    src = fetchegg {
      name = "matchable";
      version = "1.0";
      sha256 = "01vy2ppq3sq0wirvsvl3dh0bwa5jqs1i6rdjdd7pnwj4nncxd1ga";
    };

    buildInputs = [
      
    ];
  };

  srfi-1 = eggDerivation {
    name = "srfi-1-0.5";

    src = fetchegg {
      name = "srfi-1";
      version = "0.5";
      sha256 = "0gh1h406xbxwm5gvc5znc93nxp9xjbhyqf7zzga08k5y6igxrlvk";
    };

    buildInputs = [
      
    ];
  };

  srfi-13 = eggDerivation {
    name = "srfi-13-0.2";

    src = fetchegg {
      name = "srfi-13";
      version = "0.2";
      sha256 = "0jazbdnn9bjm7wwxqq7xzqxc9zfvaapq565rf1czj6ayl96yvk3n";
    };

    buildInputs = [
      srfi-14
    ];
  };

  srfi-14 = eggDerivation {
    name = "srfi-14-0.2";

    src = fetchegg {
      name = "srfi-14";
      version = "0.2";
      sha256 = "13nm4nn1d52nkvhjizy26z3s6q41x1ml4zm847xzf86x1zwvymni";
    };

    buildInputs = [
      
    ];
  };

  srfi-37 = eggDerivation {
    name = "srfi-37-1.4";

    src = fetchegg {
      name = "srfi-37";
      version = "1.4";
      sha256 = "17f593497n70gldkj6iab6ilgryiqar051v6azn1szhnm1lk7dwd";
    };

    buildInputs = [
      
    ];
  };
}

