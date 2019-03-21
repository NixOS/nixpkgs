{ pkgs }:
rec {
  inherit (pkgs) eggDerivation fetchegg;

  base64 = eggDerivation {
    name = "base64-3.3.1";

    src = fetchegg {
      name = "base64";
      version = "3.3.1";
      sha256 = "0wmldiwwg1jpcn07wb906nc53si5j7sa83wgyq643xzqcx4v4x1d";
    };

    buildInputs = [
      
    ];
  };

  blob-utils = eggDerivation {
    name = "blob-utils-1.0.3";

    src = fetchegg {
      name = "blob-utils";
      version = "1.0.3";
      sha256 = "17vdn02fnxnjx5ixgqimln93lqvzyq4y9w02fw7xnbdcjzqm0xml";
    };

    buildInputs = [
      setup-helper
      string-utils
    ];
  };

  check-errors = eggDerivation {
    name = "check-errors-1.13.0";

    src = fetchegg {
      name = "check-errors";
      version = "1.13.0";
      sha256 = "12a0sn82n98jybh72zb39fdddmr5k4785xglxb16750fhy8rmjwi";
    };

    buildInputs = [
      setup-helper
    ];
  };

  defstruct = eggDerivation {
    name = "defstruct-1.6";

    src = fetchegg {
      name = "defstruct";
      version = "1.6";
      sha256 = "0lsgl32nmb5hxqiii4r3292cx5vqh50kp6v062nfiyid9lhrj0li";
    };

    buildInputs = [
      
    ];
  };

  http-client = eggDerivation {
    name = "http-client-0.7.1";

    src = fetchegg {
      name = "http-client";
      version = "0.7.1";
      sha256 = "1s03zgmb7kb99ld0f2ylqgicrab9qgza53fkgsqvg7bh5njmzhxr";
    };

    buildInputs = [
      intarweb
      uri-common
      message-digest
      md5
      string-utils
      sendfile
    ];
  };

  intarweb = eggDerivation {
    name = "intarweb-1.3";

    src = fetchegg {
      name = "intarweb";
      version = "1.3";
      sha256 = "0izlby78c25py29bdcbc0vapb6h7xgchqrzi6i51d0rb3mnwy88h";
    };

    buildInputs = [
      defstruct
      uri-common
      base64
    ];
  };

  lookup-table = eggDerivation {
    name = "lookup-table-1.13.5";

    src = fetchegg {
      name = "lookup-table";
      version = "1.13.5";
      sha256 = "1nzly6rhynawlvzlyilk8z8cxz57cf9n5iv20glkhh28pz2izmrb";
    };

    buildInputs = [
      setup-helper
      check-errors
      miscmacros
      record-variants
      synch
    ];
  };

  matchable = eggDerivation {
    name = "matchable-3.3";

    src = fetchegg {
      name = "matchable";
      version = "3.3";
      sha256 = "07y3lpzgm4djiwi9y2adc796f9kwkmdr28fkfkw65syahdax8990";
    };

    buildInputs = [
      
    ];
  };

  md5 = eggDerivation {
    name = "md5-3.1.0";

    src = fetchegg {
      name = "md5";
      version = "3.1.0";
      sha256 = "0bka43nx8x9b0b079qpvml2fl20km19ny0qjmhwzlh6rwmzazj2a";
    };

    buildInputs = [
      message-digest
    ];
  };

  message-digest = eggDerivation {
    name = "message-digest-3.1.0";

    src = fetchegg {
      name = "message-digest";
      version = "3.1.0";
      sha256 = "1w6bax19dwgih78vcimiws0rja7qsd8hmbm6qqg2hf9cw3vab21s";
    };

    buildInputs = [
      setup-helper
      miscmacros
      check-errors
      variable-item
      blob-utils
      string-utils
    ];
  };

  miscmacros = eggDerivation {
    name = "miscmacros-2.96";

    src = fetchegg {
      name = "miscmacros";
      version = "2.96";
      sha256 = "1ajdgjrni10i2hmhcp4rawnxajjxry3kmq1krdmah4sf0kjrgajc";
    };

    buildInputs = [
      
    ];
  };

  record-variants = eggDerivation {
    name = "record-variants-0.5.1";

    src = fetchegg {
      name = "record-variants";
      version = "0.5.1";
      sha256 = "15wgysxkm8m4hx9nhhw9akchzipdnqc7yj3qd3zn0z7sxg4sld1h";
    };

    buildInputs = [
      
    ];
  };

  sendfile = eggDerivation {
    name = "sendfile-1.7.29";

    src = fetchegg {
      name = "sendfile";
      version = "1.7.29";
      sha256 = "1dc02cbkx5kixhbqjy26g6gs680vy7krc9qis1p1v4aa0b2lgj7k";
    };

    buildInputs = [
      
    ];
  };

  setup-helper = eggDerivation {
    name = "setup-helper-1.5.4";

    src = fetchegg {
      name = "setup-helper";
      version = "1.5.4";
      sha256 = "1k644y0md2isdcvazqfm4nyc8rh3dby6b0j3r4na4w8ryspqp6gj";
    };

    buildInputs = [
      
    ];
  };

  string-utils = eggDerivation {
    name = "string-utils-1.2.4";

    src = fetchegg {
      name = "string-utils";
      version = "1.2.4";
      sha256 = "07alvghg0dahilrm4jg44bndl0x69sv1zbna9l20cbdvi35i0jp1";
    };

    buildInputs = [
      setup-helper
      miscmacros
      lookup-table
      check-errors
    ];
  };

  synch = eggDerivation {
    name = "synch-2.1.2";

    src = fetchegg {
      name = "synch";
      version = "2.1.2";
      sha256 = "1m9mnbq0m5jsxmd1a3rqpwpxj0l1b7vn1fknvxycc047pmlcyl00";
    };

    buildInputs = [
      setup-helper
      check-errors
    ];
  };

  uri-common = eggDerivation {
    name = "uri-common-1.4";

    src = fetchegg {
      name = "uri-common";
      version = "1.4";
      sha256 = "01ds1gixcn4rz657x3hr4rhw2496hsjff42ninw0k39l8i1cbh7c";
    };

    buildInputs = [
      uri-generic
      defstruct
      matchable
    ];
  };

  uri-generic = eggDerivation {
    name = "uri-generic-2.41";

    src = fetchegg {
      name = "uri-generic";
      version = "2.41";
      sha256 = "1r5jbzjllbnmhm5n0m3fcx0g6dc2c2jzp1dcndkfmxz0cl99zxac";
    };

    buildInputs = [
      matchable
      defstruct
    ];
  };

  variable-item = eggDerivation {
    name = "variable-item-1.3.1";

    src = fetchegg {
      name = "variable-item";
      version = "1.3.1";
      sha256 = "19b3mhb8kr892sz9yyzq79l0vv28dgilw9cf415kj6aq16yp4d5n";
    };

    buildInputs = [
      setup-helper
      check-errors
    ];
  };
}

