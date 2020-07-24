{ pkgs, stdenv }:
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
    name = "http-client-0.18";

    src = fetchegg {
      name = "http-client";
      version = "0.18";
      sha256 = "1b9x66kfcglld4xhm06vba00gw37vr07c859kj7lmwnk9nwhcplg";
    };

    buildInputs = [
      intarweb
      uri-common
      simple-md5
      sendfile
    ];
  };

  intarweb = eggDerivation {
    name = "intarweb-1.7";

    src = fetchegg {
      name = "intarweb";
      version = "1.7";
      sha256 = "1arjgn5g4jfdzj3nlrhxk235qwf6k6jxr14yhnncnfbgdb820xp8";
    };

    buildInputs = [
      defstruct
      uri-common
      base64
    ];
  };

  matchable = eggDerivation {
    name = "matchable-3.7";

    src = fetchegg {
      name = "matchable";
      version = "3.7";
      sha256 = "1vc9rpb44fhn0n91hzglin986dw9zj87fikvfrd7j308z22a41yh";
    };

    buildInputs = [
      
    ];
  };

  sendfile = eggDerivation {
    name = "sendfile-1.8.3";

    src = fetchegg {
      name = "sendfile";
      version = "1.8.3";
      sha256 = "036x4xdndx7qly94afnag5b9idd1yymdm8d832w2cy054y7lxqsi";
    };

    buildInputs = [
      
    ];
  };

  simple-md5 = eggDerivation {
    name = "simple-md5-0.0.1";

    src = fetchegg {
      name = "simple-md5";
      version = "0.0.1";
      sha256 = "1h0b51p9wl1dl3pzs39hdq3hk2qnjgn8n750bgmh0651g4lzmq3i";
    };

    buildInputs = [
      
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
    name = "uri-generic-2.46";

    src = fetchegg {
      name = "uri-generic";
      version = "2.46";
      sha256 = "10ivf4xlmr6jcm00l2phq1y73hjv6g3qgr38ycc8rw56wv6sbm4g";
    };

    buildInputs = [
      matchable
    ];
  };
}

