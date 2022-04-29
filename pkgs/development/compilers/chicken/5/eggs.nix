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
    name = "matchable-1.1";

    src = fetchegg {
      name = "matchable";
      version = "1.1";
      sha256 = "084hm5dvbvgnpb32ispkp3hjili8z02hamln860r99jx68jx6j2v";
    };

    buildInputs = [
      
    ];
  };

  r7rs = eggDerivation {
    name = "r7rs-1.0.5";

    src = fetchegg {
      name = "r7rs";
      version = "1.0.5";
      sha256 = "0zyi1z4m1995hm2wfc5wpi8jjgxcwk03qknq5v2ygff3akxazsf6";
    };

    buildInputs = [
      matchable
      srfi-1
      srfi-13
    ];
  };

  srfi-1 = eggDerivation {
    name = "srfi-1-0.5.1";

    src = fetchegg {
      name = "srfi-1";
      version = "0.5.1";
      sha256 = "15x0ajdkw5gb3vgs8flzh5g0pzl3wmcpf11iimlm67mw6fxc8p7j";
    };

    buildInputs = [
      
    ];
  };

  srfi-13 = eggDerivation {
    name = "srfi-13-0.3.1";

    src = fetchegg {
      name = "srfi-13";
      version = "0.3.1";
      sha256 = "12ryxs3w3las0wjdh0yp52g1xmyq1fb48xi3i26l5a9sfx7gbilp";
    };

    buildInputs = [
      srfi-14
    ];
  };

  srfi-14 = eggDerivation {
    name = "srfi-14-0.2.1";

    src = fetchegg {
      name = "srfi-14";
      version = "0.2.1";
      sha256 = "0gc33cx4xll9vsf7fm8jvn3gc0604kn3bbi6jfn6xscqp86kqb9p";
    };

    buildInputs = [
      
    ];
  };

  srfi-145 = eggDerivation {
    name = "srfi-145-0.1";

    src = fetchegg {
      name = "srfi-145";
      version = "0.1";
      sha256 = "1r4278xhpmm8gww64j6akpyv3qjnn14b6nsisyb9qm7yx3pkpim9";
    };

    buildInputs = [
      
    ];
  };

  srfi-189 = eggDerivation {
    name = "srfi-189-0.1";

    src = fetchegg {
      name = "srfi-189";
      version = "0.1";
      sha256 = "1nmrywpi9adi5mm1vcbxxsgw0j3v6m7s4j1mii7icj83xn81cgvx";
    };

    buildInputs = [
      r7rs
      srfi-1
      srfi-145
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

