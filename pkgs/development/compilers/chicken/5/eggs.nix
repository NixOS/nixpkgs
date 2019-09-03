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
    name = "srfi-13-0.2.1";

    src = fetchegg {
      name = "srfi-13";
      version = "0.2.1";
      sha256 = "0204i7fhc4dy0l89lbi2lv9cjndrvwyrk68z3wy7x445jb4ky1gq";
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

