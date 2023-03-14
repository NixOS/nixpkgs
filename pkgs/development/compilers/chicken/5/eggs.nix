{ pkgs, stdenv }:
rec {
  inherit (pkgs) eggDerivation fetchegg;

  address-info = eggDerivation {
    name = "address-info-1.0.5";

    src = fetchegg {
      name = "address-info";
      version = "1.0.5";
      sha256 = "1nv87ghfv8szmi2l0rybrgrds6fs5w6jxafqslnzw0mw5sfj6jyk";
    };

    buildInputs = [
      srfi-1
    ];
  };

  apropos = eggDerivation {
    name = "apropos-3.6.0";

    src = fetchegg {
      name = "apropos";
      version = "3.6.0";
      sha256 = "0jq5d4zijbf5dw2vsfn89smp7zjpgp82y5hs10xkysf831x7l551";
    };

    buildInputs = [
      srfi-1
      srfi-13
      check-errors
      string-utils
      symbol-utils
    ];
  };

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

  base64 = eggDerivation {
    name = "base64-1.0";

    src = fetchegg {
      name = "base64";
      version = "1.0";
      sha256 = "01lid9wxf94nr7gmskamxlfngack1hyxig8rl9swwgnbmz9qgysi";
    };

    buildInputs = [
      srfi-13
    ];
  };

  check-errors = eggDerivation {
    name = "check-errors-3.2.0";

    src = fetchegg {
      name = "check-errors";
      version = "3.2.0";
      sha256 = "0d0hpq1nmwyvbg162bqzgk62f70rin0pxsr5a3pgx6xin5i3ngah";
    };

    buildInputs = [
      
    ];
  };

  defstruct = eggDerivation {
    name = "defstruct-2.0";

    src = fetchegg {
      name = "defstruct";
      version = "2.0";
      sha256 = "0q1v1gdwqlpmwcsa4jnqldfqky9k7kvb83qgkhdyqym52bm5aln8";
    };

    buildInputs = [
      srfi-1
    ];
  };

  feature-test = eggDerivation {
    name = "feature-test-0.2.0";

    src = fetchegg {
      name = "feature-test";
      version = "0.2.0";
      sha256 = "1dxdisv64d8alg6r45cwxf5gmdpcvql1hvlq808lgwphd7kvfpgr";
    };

    buildInputs = [
      
    ];
  };

  foreigners = eggDerivation {
    name = "foreigners-1.5";

    src = fetchegg {
      name = "foreigners";
      version = "1.5";
      sha256 = "1mm91y61nlawgb7iqdrkz2fi9sc3fic07f5m1ig541b2hbscfiqy";
    };

    buildInputs = [
      matchable
    ];
  };

  intarweb = eggDerivation {
    name = "intarweb-2.0.1";

    src = fetchegg {
      name = "intarweb";
      version = "2.0.1";
      sha256 = "0md226jikqhj993cw17588ipmnz0v7l34zrvylamyrs6zbvj3scm";
    };

    buildInputs = [
      srfi-1
      srfi-13
      srfi-14
      defstruct
      uri-common
      base64
    ];
  };

  iset = eggDerivation {
    name = "iset-2.2";

    src = fetchegg {
      name = "iset";
      version = "2.2";
      sha256 = "0yfkcd07cw6xnnqfbbvjy81x0vc54k40vdjp2m7gwxx64is6m3rz";
    };

    buildInputs = [
      
    ];
  };

  json = eggDerivation {
    name = "json-1.6";

    src = fetchegg {
      name = "json";
      version = "1.6";
      sha256 = "0sb8285dqrm27c8zaqfzc0gixvfmvf0cq2nbza8c4z7j5snxzs2w";
    };

    buildInputs = [
      packrat
      srfi-1
      srfi-69
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

  memory-mapped-files = eggDerivation {
    name = "memory-mapped-files-0.4";

    src = fetchegg {
      name = "memory-mapped-files";
      version = "0.4";
      sha256 = "0by3r18bj9fs0bs9w5czx84vssmr58br3x7pz1m3myb4mns3mpsc";
    };

    buildInputs = [
      
    ];
  };

  message-digest-primitive = eggDerivation {
    name = "message-digest-primitive-4.3.2";

    src = fetchegg {
      name = "message-digest-primitive";
      version = "4.3.2";
      sha256 = "1wfmyyp1fv0sz70m0rgzbhkiqgzjc15ppz7fwmpnxg12rvfzdvq0";
    };

    buildInputs = [
      check-errors
    ];
  };

  miscmacros = eggDerivation {
    name = "miscmacros-1.0";

    src = fetchegg {
      name = "miscmacros";
      version = "1.0";
      sha256 = "0n2ia4ib4f18hcbkm5byph07ncyx61pcpfp2qr5zijf8ykp8nbvr";
    };

    buildInputs = [
      
    ];
  };

  packrat = eggDerivation {
    name = "packrat-1.5";

    src = fetchegg {
      name = "packrat";
      version = "1.5";
      sha256 = "0hfnh57a8yga3byrk8522al5wdj7dyz48lixvvcgnsn3vdy333hq";
    };

    buildInputs = [
      srfi-1
    ];
  };

  regex = eggDerivation {
    name = "regex-2.0";

    src = fetchegg {
      name = "regex";
      version = "2.0";
      sha256 = "0qgqrrdr95yqggw8xyvb693nhizwqvf1fp9cjx9p3z80c4ih8j4j";
    };

    buildInputs = [
      
    ];
  };

  sendfile = eggDerivation {
    name = "sendfile-1.8.3";

    src = fetchegg {
      name = "sendfile";
      version = "1.8.3";
      sha256 = "0acmydjxlrbq7bdspmrzv9q9l3gh4xxnbpi5g1d5mz1g2mjwgm63";
    };

    buildInputs = [
      memory-mapped-files
    ];
  };

  sha2 = eggDerivation {
    name = "sha2-4.0.5";

    src = fetchegg {
      name = "sha2";
      version = "4.0.5";
      sha256 = "020yc41gkpg2s48v5n1nnq02dii340yly2y1zsi71bbfbkai2vcs";
    };

    buildInputs = [
      message-digest-primitive
    ];
  };

  socket = eggDerivation {
    name = "socket-0.3.3";

    src = fetchegg {
      name = "socket";
      version = "0.3.3";
      sha256 = "04wfxrwjizvf1jdpfqp3r7381rp9lscrm3z21ihq2dc2lfzjgrxw";
    };

    buildInputs = [
      srfi-13
      srfi-18
      foreigners
      feature-test
    ];
  };

  spiffy = eggDerivation {
    name = "spiffy-6.3";

    src = fetchegg {
      name = "spiffy";
      version = "6.3";
      sha256 = "0f22gfdyysgbm3q6cjibn1z1yavks3imxi1mxcyfmms3x91k5k3c";
    };

    buildInputs = [
      intarweb
      uri-common
      uri-generic
      sendfile
      srfi-1
      srfi-13
      srfi-14
      srfi-18
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

  srfi-18 = eggDerivation {
    name = "srfi-18-0.1.6";

    src = fetchegg {
      name = "srfi-18";
      version = "0.1.6";
      sha256 = "00lykm5lqbrcxl3dab9dqwimpgm36v4ys2957k3vdlg4xdb1abfa";
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

  srfi-69 = eggDerivation {
    name = "srfi-69-0.4.1";

    src = fetchegg {
      name = "srfi-69";
      version = "0.4.1";
      sha256 = "1l102kppncz27acsr4jyi46q0r7g2lb6gdbkd6p3h1xmvwcnk2hl";
    };

    buildInputs = [
      
    ];
  };

  string-utils = eggDerivation {
    name = "string-utils-2.4.0";

    src = fetchegg {
      name = "string-utils";
      version = "2.4.0";
      sha256 = "09m3s0p199r2nmvc8qnqvbxjbq967gvwqrzp236wsw3hdcil6p8v";
    };

    buildInputs = [
      srfi-1
      srfi-13
      srfi-69
      miscmacros
      check-errors
      utf8
    ];
  };

  symbol-utils = eggDerivation {
    name = "symbol-utils-2.1.0";

    src = fetchegg {
      name = "symbol-utils";
      version = "2.1.0";
      sha256 = "17nq8bj18f3bbf3mdfx1m8agy97izn1xcl8ymvgvvd5g384b2xil";
    };

    buildInputs = [
      check-errors
    ];
  };

  tcp6 = eggDerivation {
    name = "tcp6-0.2.1";

    src = fetchegg {
      name = "tcp6";
      version = "0.2.1";
      sha256 = "14dynnjgac28f46v781hi6kam326q6rh57pf0pvl0chdva4hlf3q";
    };

    buildInputs = [
      socket
      srfi-1
    ];
  };

  uri-common = eggDerivation {
    name = "uri-common-2.0";

    src = fetchegg {
      name = "uri-common";
      version = "2.0";
      sha256 = "07rq7ppkyk3i85vqspc048pnj6gmjhj236z00chslli9xybqkgrd";
    };

    buildInputs = [
      uri-generic
      defstruct
      matchable
      srfi-1
      srfi-13
      srfi-14
    ];
  };

  uri-generic = eggDerivation {
    name = "uri-generic-3.2";

    src = fetchegg {
      name = "uri-generic";
      version = "3.2";
      sha256 = "1lpvnk1mnhmrga149km7ygpy7fkq7z2pvw0mvpx2aql03l8gpdsj";
    };

    buildInputs = [
      matchable
      srfi-1
      srfi-14
    ];
  };

  utf8 = eggDerivation {
    name = "utf8-3.6.2";

    src = fetchegg {
      name = "utf8";
      version = "3.6.2";
      sha256 = "10wzp3qmwik4gx3hhaqm2n83wza0rllgy57363h5ccv8fga5nnm6";
    };

    buildInputs = [
      srfi-69
      iset
      regex
    ];
  };
}

