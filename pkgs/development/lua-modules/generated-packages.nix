/* pkgs/development/lua-modules/generated-packages.nix is an auto-generated file -- DO NOT EDIT!
Regenerate it with:
nixpkgs$ ./maintainers/scripts/update-luarocks-packages

You can customize the generated packages in pkgs/development/lua-modules/overrides.nix
*/

{ self, stdenv, lib, fetchurl, fetchgit, callPackage, ... } @ args:
final: prev:
{
alt-getopt = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "alt-getopt";
  version = "0.8.0-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/alt-getopt-0.8.0-1.rockspec";
    sha256 = "17yxi1lsrbkmwzcn1x48x8758d7v1frsz1bmnpqfv4vfnlh0x210";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/cheusov/lua-alt-getopt",
  "rev": "f495c21d6a203ab280603aa5799e636fb5651ae7",
  "date": "2017-01-06T13:50:55+03:00",
  "path": "/nix/store/z72v77cw9188408ynsppwhlzii2dr740-lua-alt-getopt",
  "sha256": "1kq7r5668045diavsqd1j6i9hxdpsk99w8q4zr8cby9y3ws4q6rv",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/cheusov/lua-alt-getopt";
    description = "Process application arguments the same way as getopt_long";
    maintainers = with lib.maintainers; [ arobyn ];
    license.fullName = "MIT/X11";
  };
}) {};

argparse = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "argparse";
  version = "scm-2";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/luarocks/argparse.git",
  "rev": "27967d7b52295ea7885671af734332038c132837",
  "date": "2020-07-08T11:17:50+10:00",
  "path": "/nix/store/vjm6c826hgvj7h7vqlbgkfpvijsd8yaf-argparse",
  "sha256": "0idg79d0dfis4qhbkbjlmddq87np75hb2vj41i6prjpvqacvg5v1",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/luarocks/argparse";
    description = "A feature-rich command-line argument parser";
    license.fullName = "MIT";
  };
}) {};

basexx = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "basexx";
  version = "scm-0";
  rockspecDir = "dist";

  src = fetchurl {
    url    = "https://github.com/aiq/basexx/archive/master.tar.gz";
    sha256 = "1x0d24aaj4zld4ifr7mi8zwrym5shsfphmwx5jzw2zg22r6xzlz1";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/aiq/basexx";
    description = "A base2, base16, base32, base64 and base85 library for Lua";
    license.fullName = "MIT";
  };
}) {};

binaryheap = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "binaryheap";
  version = "0.4-1";

  src = fetchurl {
    url    = "https://github.com/Tieske/binaryheap.lua/archive/version_0v4.tar.gz";
    sha256 = "0f5l4nb5s7dycbkgh3rrl7pf0npcf9k6m2gr2bsn09fjyb3bdc8h";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/Tieske/binaryheap.lua";
    description = "Binary heap implementation in pure Lua";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT/X11";
  };
}) {};

bit32 = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "bit32";
  version = "5.3.0-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/bit32-5.3.0-1.rockspec";
    sha256 = "1d6xdihpksrj5a3yvsvnmf3vfk15hj6f8n1rrs65m7adh87hc0yd";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/lua-compat-5.2.git",
  "rev": "10c7d40943601eb1f80caa9e909688bb203edc4d",
  "date": "2015-02-17T10:44:04+01:00",
  "path": "/nix/store/9kz7kgjmq0w9plrpha866bmwsgp4rfhn-lua-compat-5.2",
  "sha256": "1ipqlbvb5w394qwhm2f3w6pdrgy8v4q8sps5hh3pqz14dcqwakhj",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.lua.org/manual/5.2/manual.html#6.7";
    description = "Lua 5.2 bit manipulation library";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT/X11";
  };
}) {};

busted = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua, lua_cliargs, luafilesystem, luasystem, dkjson, say, luassert, lua-term, penlight, mediator_lua
}:
buildLuarocksPackage {
  pname = "busted";
  version = "2.0.0-1";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/busted-2.0.0-1.rockspec";
    sha256 = "0cbw95bjxl667n9apcgng2kr5hq6bc7gp3vryw4dzixmfabxkcbw";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/Olivine-Labs/busted/archive/v2.0.0.tar.gz";
    sha256 = "1ps7b3f4diawfj637mibznaw4x08gn567pyni0m2s50hrnw4v8zx";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua_cliargs luafilesystem luasystem dkjson say luassert lua-term penlight mediator_lua ];

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description = "Elegant Lua unit testing.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

cassowary = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, penlight
}:
buildLuarocksPackage {
  pname = "cassowary";
  version = "2.3.1-2";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/cassowary-2.3.1-2.rockspec";
    sha256 = "04y882f9ai1jhk0zwla2g0fvl56a75rwnxhsl9r3m0qa5i0ia1i5";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/sile-typesetter/cassowary.lua",
  "rev": "c022a120dee86979d18e4c4613e55e721c632d80",
  "date": "2021-07-19T14:37:34+03:00",
  "path": "/nix/store/rzsbr6gqg8vhchl24ma3p1h4slhk0xp7-cassowary.lua",
  "sha256": "1r668qcvd2a1rx17xp7ajp5wjhyvh2fwn0c60xmw0mnarjb5w1pq",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua penlight ];

  meta = {
    homepage = "https://github.com/sile-typesetter/cassowary.lua";
    description = "The cassowary constraint solver";
    maintainers = with lib.maintainers; [ marsam alerque ];
    license.fullName = "Apache 2";
  };
}) {};

compat53 = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "compat53";
  version = "0.7-1";
  knownRockspec = (fetchurl {
    url    = "https://luafr.org/luarocks/compat53-0.7-1.rockspec";
    sha256 = "1r7a3q1cjrcmdycrv2ikgl83irjhxs53sa88v2fdpr9aaamlb101";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/keplerproject/lua-compat-5.3/archive/v0.7.zip";
    sha256 = "1x3wv1qx7b2zlf3fh4q9pmi2xxkcdm024g7bf11rpv0yacnhran3";
  };

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/keplerproject/lua-compat-5.3";
    description = "Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT";
  };
}) {};

cosmo = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lpeg
}:
buildLuarocksPackage {
  pname = "cosmo";
  version = "16.06.04-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/cosmo-16.06.04-1.rockspec";
    sha256 = "0ipv1hrlhvaz1myz6qxabq7b7kb3bz456cya3r292487a3g9h9pb";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mascarenhas/cosmo.git",
  "rev": "e774f08cbf8d271185812a803536af8a8240ac51",
  "date": "2016-06-17T05:39:58-07:00",
  "path": "/nix/store/k3p4xc4cfihp4h8aj6vacr25rpcsjd96-cosmo",
  "sha256": "03b5gwsgxd777970d2h6rx86p7ivqx7bry8xmx2r396g3w85qy2p",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  propagatedBuildInputs = [ lpeg ];

  meta = {
    homepage = "http://cosmo.luaforge.net";
    description = "Safe templates for Lua";
    maintainers = with lib.maintainers; [ marsam ];
    license.fullName = "MIT/X11";
  };
}) {};

coxpcall = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit}:
buildLuarocksPackage {
  pname = "coxpcall";
  version = "1.17.0-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/coxpcall-1.17.0-1.rockspec";
    sha256 = "0mf0nggg4ajahy5y1q5zh2zx9rmgzw06572bxx6k8b736b8j7gca";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/coxpcall",
  "rev": "ea22f44e490430e40217f0792bf82eaeaec51903",
  "date": "2018-02-26T19:53:11-03:00",
  "path": "/nix/store/1q4p5qvr6rlwisyarlgnmk4dx6vp8xdl-coxpcall",
  "sha256": "1k3q1rr2kavkscf99b5njxhibhp6iwhclrjk6nnnp233iwc2jvqi",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;


  meta = {
    homepage = "http://keplerproject.github.io/coxpcall";
    description = "Coroutine safe xpcall and pcall";
    license.fullName = "MIT/X11";
  };
}) {};

cqueues = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "cqueues";
  version = "20200726.52-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/cqueues-20200726.52-0.rockspec";
    sha256 = "0w2kq9w0wda56k02rjmvmzccz6bc3mn70s9v7npjadh85i5zlhhp";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/wahern/cqueues/archive/rel-20200726.tar.gz";
    sha256 = "0lhd02ag3r1sxr2hx847rdjkddm04l1vf5234v5cz9bd4kfjw4cy";
  };

  disabled = with lua; (luaversion != "5.2");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://25thandclement.com/~william/projects/cqueues.html";
    description = "Continuation Queues: Embeddable asynchronous networking, threading, and notification framework for Lua on Unix.";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT/X11";
  };
}) {};

cyrussasl = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "cyrussasl";
  version = "1.1.0-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/JorjBauer/lua-cyrussasl",
  "rev": "78ceec610da76d745d0eff4e21a4fb24832aa72d",
  "date": "2015-08-21T18:24:54-04:00",
  "path": "/nix/store/s7n7f80pz8k6lvfav55a5rwy5l45vs4l-lua-cyrussasl",
  "sha256": "14kzm3vk96k2i1m9f5zvpvq4pnzaf7s91h5g4h4x2bq1mynzw2s1",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/JorjBauer/lua-cyrussasl";
    description = "Cyrus SASL library for Lua 5.1+";
    license.fullName = "BSD";
  };
}) {};

digestif = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, lpeg
}:
buildLuarocksPackage {
  pname = "digestif";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/astoff/digestif",
  "rev": "505ca88a54012be5534654238baaa457f8446fed",
  "date": "2021-10-06T21:27:45+02:00",
  "path": "/nix/store/6wvpy0nsr5yf78by3dg8m2m0h0kf9xk4-digestif",
  "sha256": "1prv5nqskvilyyx3z9b2jiz72lwpz2xcas57qjpbv6qq5l2si1xm",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.3");
  propagatedBuildInputs = [ lua lpeg ];

  meta = {
    homepage = "https://github.com/astoff/digestif/";
    description = "A code analyzer for TeX";
    license.fullName = "MIT";
  };
}) {};

dkjson = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "dkjson";
  version = "2.5-3";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/dkjson-2.5-3.rockspec";
    sha256 = "18xngdzl2q207cil64aj81qi6qvj1g269pf07j5x4pbvamd6a1l3";
  }).outPath;
  src = fetchurl {
    url    = "http://dkolf.de/src/dkjson-lua.fsl/tarball/dkjson-2.5.tar.gz?uuid=release_2_5";
    sha256 = "14wanday1l7wj2lnpabbxw8rcsa0zbvcdi1w88rdr5gbsq3xwasm";
  };

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://dkolf.de/src/dkjson-lua.fsl/";
    description = "David Kolf's JSON module for Lua";
    license.fullName = "MIT/X11";
  };
}) {};

fifo = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "fifo";
  version = "0.2-0";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/fifo-0.2-0.rockspec";
    sha256 = "0vr9apmai2cyra2n573nr3dyk929gzcs4nm1096jdxcixmvh2ymq";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/daurnimator/fifo.lua/archive/0.2.zip";
    sha256 = "1a028yyc1xlkaavij8rkz18dqf96risrj65xp0p72y2mhsrckdp1";
  };

  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/daurnimator/fifo.lua";
    description = "A lua library/'class' that implements a FIFO";
    license.fullName = "MIT/X11";
  };
}) {};

gitsigns-nvim = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, plenary-nvim
}:
buildLuarocksPackage {
  pname = "gitsigns.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lewis6991/gitsigns.nvim",
  "rev": "552f114caeaec4ce97822cb55dfa7c7e5368136b",
  "date": "2021-10-15T13:31:44+01:00",
  "path": "/nix/store/40vkv3sc4h6gh9ac88k7pilszxmy38yv-gitsigns.nvim",
  "sha256": "0qdafm3arjf8bcqpvv085dwzbikad3sr3xzvrn3gfa0dsls8pg6q",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaversion != "5.1");
  propagatedBuildInputs = [ lua plenary-nvim ];

  meta = {
    homepage = "http://github.com/lewis6991/gitsigns.nvim";
    description = "Git signs written in pure lua";
    license.fullName = "MIT/X11";
  };
}) {};

http = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua, compat53, bit32, cqueues, luaossl, basexx, lpeg, lpeg_patterns, binaryheap, fifo
}:
buildLuarocksPackage {
  pname = "http";
  version = "0.3-0";
  knownRockspec = (fetchurl {
    url    = "https://luafr.org/luarocks/http-0.3-0.rockspec";
    sha256 = "0fn3irkf5nnmfc83alc40b316hs8l7zdq2xlaiaa65sjd8acfvia";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/daurnimator/lua-http/archive/v0.3.zip";
    sha256 = "13xyj8qx42mzn1z4lwwdfd7ha06a720q4b7d04ir6vvp2fwp3s4q";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua compat53 bit32 cqueues luaossl basexx lpeg lpeg_patterns binaryheap fifo ];

  meta = {
    homepage = "https://github.com/daurnimator/lua-http";
    description = "HTTP library for Lua";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT";
  };
}) {};

inspect = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "inspect";
  version = "3.1.1-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/inspect-3.1.1-0.rockspec";
    sha256 = "00spibq2h4an8v0204vr1hny4vv6za720c37ipsahpjk198ayf1p";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/kikito/inspect.lua/archive/v3.1.1.tar.gz";
    sha256 = "1nz0yqhkd0nkymghrj99gb2id40g50drh4a96g3v5k7h1sbg94h2";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/kikito/inspect.lua";
    description = "Lua table visualizer, ideal for debugging";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

ldbus = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "ldbus";
  version = "scm-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/ldbus-scm-0.rockspec";
    sha256 = "1yhkw5y8h1qf44vx31934k042cmnc7zcv2k0pv0g27wsmlxrlznx";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/daurnimator/ldbus.git",
  "rev": "9e176fe851006037a643610e6d8f3a8e597d4073",
  "date": "2019-08-16T14:26:05+10:00",
  "path": "/nix/store/gg4zldd6kx048d6p65b9cimg3arma8yh-ldbus",
  "sha256": "06wcz4i5b7kphqbry274q3ivnsh331rxiyf7n4qk3zx2kvarq08s",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/daurnimator/ldbus";
    description = "A Lua library to access dbus.";
    license.fullName = "MIT/X11";
  };
}) {};

ldoc = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, penlight, markdown
}:
buildLuarocksPackage {
  pname = "ldoc";
  version = "scm-3";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/stevedonovan/LDoc.git",
  "rev": "bbd498ab39fa49318b36378430d3cdab571f8ba0",
  "date": "2021-06-24T13:07:51+02:00",
  "path": "/nix/store/pzk1qi4fdviz2pq5bg3q91jmrg8wziqx-LDoc",
  "sha256": "05wd5m5v3gv777kgikj46216slxyf1zdbzl4idara9lcfw3mfyyw",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  propagatedBuildInputs = [ penlight markdown ];

  meta = {
    homepage = "http://stevedonovan.github.com/ldoc";
    description = "A Lua Documentation Tool";
    license.fullName = "MIT/X11";
  };
}) {};

lgi = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lgi";
  version = "0.9.2-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lgi-0.9.2-1.rockspec";
    sha256 = "1gqi07m4bs7xibsy4vx8qgyp3yb1wnh0gdq1cpwqzv35y6hn5ds3";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/pavouk/lgi.git",
  "rev": "0fdcf8c677094d0c109dfb199031fdbc0c9c47ea",
  "date": "2017-10-09T20:55:55+02:00",
  "path": "/nix/store/vh82n8pc8dy5c8nph0vssk99vv7q4qg2-lgi",
  "sha256": "03rbydnj411xpjvwsyvhwy4plm96481d7jax544mvk7apd8sd5jj",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/pavouk/lgi";
    description = "Lua bindings to GObject libraries";
    license.fullName = "MIT/X11";
  };
}) {};

linenoise = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "linenoise";
  version = "0.9-1";

  src = fetchurl {
    url    = "https://github.com/hoelzro/lua-linenoise/archive/0.9.tar.gz";
    sha256 = "177h6gbq89arwiwxah9943i8hl5gvd9wivnd1nhmdl7d8x0dn76c";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/hoelzro/lua-linenoise";
    description = "A binding for the linenoise command line library";
    license.fullName = "MIT/X11";
  };
}) {};

ljsyscall = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "ljsyscall";
  version = "0.12-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/ljsyscall-0.12-1.rockspec";
    sha256 = "0zna5s852vn7q414z56kkyqwpighaghyq7h7in3myap4d9vcgm01";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/justincormack/ljsyscall/archive/v0.12.tar.gz";
    sha256 = "1w9g36nhxv92cypjia7igg1xpfrn3dbs3hfy6gnnz5mx14v50abf";
  };

  disabled = with lua; (luaversion != "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.myriabit.com/ljsyscall/";
    description = "LuaJIT Linux syscall FFI";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT";
  };
}) {};

lpeg = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "lpeg";
  version = "1.0.2-1";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lpeg-1.0.2-1.rockspec";
    sha256 = "08a8p5cwlwpjawk8sczb7bq2whdsng4mmhphahyklf1bkvl2li89";
  }).outPath;
  src = fetchurl {
    url    = "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.2.tar.gz";
    sha256 = "1zjzl7acvcdavmcg5l7wi12jd4rh95q9pl5aiww7hv0v0mv6bmj8";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.inf.puc-rio.br/~roberto/lpeg.html";
    description = "Parsing Expression Grammars For Lua";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

lpeg_patterns = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua, lpeg
}:
buildLuarocksPackage {
  pname = "lpeg_patterns";
  version = "0.5-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lpeg_patterns-0.5-0.rockspec";
    sha256 = "1vzl3ryryc624mchclzsfl3hsrprb9q214zbi1xsjcc4ckq5qfh7";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/daurnimator/lpeg_patterns/archive/v0.5.zip";
    sha256 = "17jizbyalzdg009p3x2260bln65xf8xhv9npr0kr93kv986j463b";
  };

  propagatedBuildInputs = [ lua lpeg ];

  meta = {
    homepage = "https://github.com/daurnimator/lpeg_patterns/archive/v0.5.zip";
    description = "a collection of LPEG patterns";
    license.fullName = "MIT";
  };
}) {};

lpeglabel = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "lpeglabel";
  version = "1.6.0-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lpeglabel-1.6.0-1.rockspec";
    sha256 = "13gc32pggng6f95xx5zw9n9ian518wlgb26mna9kh4q2xa1k42pm";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/sqmedeiros/lpeglabel/archive/v1.6.0-1.tar.gz";
    sha256 = "1i02lsxj20iygqm8fy6dih1gh21lqk5qj1mv14wlrkaywnv35wcv";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/sqmedeiros/lpeglabel/";
    description = "Parsing Expression Grammars For Lua with Labeled Failures";
    license.fullName = "MIT/X11";
  };
}) {};

lpty = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "lpty";
  version = "1.2.2-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lpty-1.2.2-1.rockspec";
    sha256 = "04af4mhiqrw3br4qzz7yznw9zy2m50wddwzgvzkvhd99ng71fkzg";
  }).outPath;
  src = fetchurl {
    url    = "http://www.tset.de/downloads/lpty-1.2.2-1.tar.gz";
    sha256 = "071mvz79wi9vr6hvrnb1rv19lqp1bh2fi742zkpv2sm1r9gy5rav";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.tset.de/lpty/";
    description = "A simple facility for lua to control other programs via PTYs.";
    license.fullName = "MIT";
  };
}) {};

lrexlib-gnu = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lrexlib-gnu";
  version = "2.9.1-1";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lrexlib-gnu-2.9.1-1.rockspec";
    sha256 = "1jfjxh26iwsavipkwmscwv52l77qxzvibfmlvpskcpawyii7xcw8";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/rrthomas/lrexlib.git",
  "rev": "69d5c442c5a4bdc1271103e88c5c798b605e9ed2",
  "date": "2020-08-07T12:10:29+03:00",
  "path": "/nix/store/vnnhcc0r9zhqwshmfzrn0ryai61l6xrd-lrexlib",
  "sha256": "15dsxq0363940rij9za8mc224n9n58i2iqw1z7r1jh3qpkaciw7j",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (GNU flavour).";
    license.fullName = "MIT/X11";
  };
}) {};

lrexlib-pcre = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lrexlib-pcre";
  version = "2.9.1-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lrexlib-pcre-2.9.1-1.rockspec";
    sha256 = "036k27xaplxn128b3p67xiqm8k40s7bxvh87wc8v2cx1cc4b9ia4";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/rrthomas/lrexlib.git",
  "rev": "69d5c442c5a4bdc1271103e88c5c798b605e9ed2",
  "date": "2020-08-07T12:10:29+03:00",
  "path": "/nix/store/vnnhcc0r9zhqwshmfzrn0ryai61l6xrd-lrexlib",
  "sha256": "15dsxq0363940rij9za8mc224n9n58i2iqw1z7r1jh3qpkaciw7j",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (PCRE flavour).";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

lrexlib-posix = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lrexlib-posix";
  version = "2.9.1-1";
  knownRockspec = (fetchurl {
    url    = "https://luafr.org/luarocks/lrexlib-posix-2.9.1-1.rockspec";
    sha256 = "1zxrx9yifm9ry4wbjgv86rlvq3ff6qivldvib3ha4767azla0j0r";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/rrthomas/lrexlib.git",
  "rev": "69d5c442c5a4bdc1271103e88c5c798b605e9ed2",
  "date": "2020-08-07T12:10:29+03:00",
  "path": "/nix/store/vnnhcc0r9zhqwshmfzrn0ryai61l6xrd-lrexlib",
  "sha256": "15dsxq0363940rij9za8mc224n9n58i2iqw1z7r1jh3qpkaciw7j",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (POSIX flavour).";
    license.fullName = "MIT/X11";
  };
}) {};

lua-cjson = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lua-cjson";
  version = "2.1.0.6-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-cjson-2.1.0.6-1.rockspec";
    sha256 = "1x6dk17lwmgkafpki99yl1hlypchbrxr9sxqafrmx7wwvzbz6q11";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/openresty/lua-cjson",
  "rev": "a03094c5473d9a9764bb486fbe5e99a62d166dae",
  "date": "2018-04-19T12:03:43-07:00",
  "path": "/nix/store/qdpqx2g0xi1c9fknzxx280mcdq6fi8rw-lua-cjson",
  "sha256": "0i2sjsi6flax1k0bm647yijgmc02jznq9bn88mj71pgii79pfjhw",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.kyne.com.au/~mark/software/lua-cjson.php";
    description = "A fast JSON encoding/parsing module";
    license.fullName = "MIT";
  };
}) {};

lua-cmsgpack = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lua-cmsgpack";
  version = "0.4.0-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-cmsgpack-0.4.0-0.rockspec";
    sha256 = "10cvr6knx3qvjcw1q9v05f2qy607mai7lbq321nx682aa0n1fzin";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/antirez/lua-cmsgpack.git",
  "rev": "dec1810a70d2948725f2e32cc38163de62b9d9a7",
  "date": "2015-06-03T08:39:04+02:00",
  "path": "/nix/store/ksqvl7hbd5s7nb6hjffyic1shldac4z2-lua-cmsgpack",
  "sha256": "0j0ahc9rprgl6dqxybaxggjam2r5i2wqqsd6764n0d7fdpj9fqm0",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/antirez/lua-cmsgpack";
    description = "MessagePack C implementation and bindings for Lua 5.1/5.2/5.3";
    license.fullName = "Two-clause BSD";
  };
}) {};

lua-iconv = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "lua-iconv";
  version = "7-3";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-iconv-7-3.rockspec";
    sha256 = "0qh5vsaxd7s31p7a8rl08lwd6zv90wnvp15nll4fcz452kffpp72";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/downloads/ittner/lua-iconv/lua-iconv-7.tar.gz";
    sha256 = "02dg5x79fg5mwsycr0fj6w04zykdpiki9xjswkkwzdalqwaikny1";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://ittner.github.com/lua-iconv/";
    description = "Lua binding to the iconv";
    license.fullName = "MIT/X11";
  };
}) {};

lua-lsp = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, dkjson, lpeglabel, inspect
}:
buildLuarocksPackage {
  pname = "lua-lsp";
  version = "0.1.0-2";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-lsp-0.1.0-2.rockspec";
    sha256 = "19jsz00qlgbyims6cg8i40la7v8kr7zsxrrr3dg0kdg0i36xqs6c";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/Alloyed/lua-lsp",
  "rev": "6afbe53b43d9fb2e70edad50081cc3062ca3d78f",
  "date": "2020-10-17T15:07:11-04:00",
  "path": "/nix/store/qn9syhm875k1qardhhsp025cm3dbnqvm-lua-lsp",
  "sha256": "17k3jq61jz6j9bz4vc3hmsfx1s26cfgq1acja8fqyixljklmsbqp",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua dkjson lpeglabel inspect ];

  meta = {
    homepage = "https://github.com/Alloyed/lua-lsp";
    description = "A Language Server implementation for lua, the language";
    license.fullName = "MIT";
  };
}) {};

lua-messagepack = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "lua-messagepack";
  version = "0.5.2-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-messagepack-0.5.2-1.rockspec";
    sha256 = "15liz6v8hsqgb3xrcd74a71nnjcz79gpc3ak351hk6k4gyjq2rfc";
  }).outPath;
  src = fetchurl {
    url    = "https://framagit.org/fperrad/lua-MessagePack/raw/releases/lua-messagepack-0.5.2.tar.gz";
    sha256 = "1jgi944d0vx4zs9lrphys9pw0wrsibip93sh141qjwymrjyjg1nc";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://fperrad.frama.io/lua-MessagePack/";
    description = "a pure Lua implementation of the MessagePack serialization format";
    license.fullName = "MIT/X11";
  };
}) {};

lua-resty-http = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lua-resty-http";
  version = "0.16.1-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-resty-http-0.16.1-0.rockspec";
    sha256 = "1475zncd9zvnrblc3r60cwf49c7v0w3khqmi6wqrc5k331m0wm8w";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/ledgetech/lua-resty-http",
  "rev": "9bf951dfe162dd9710a0e1f4525738d4902e9d20",
  "date": "2021-04-09T17:11:35+01:00",
  "path": "/nix/store/zzd1xj4r0iy3srs2hgv4mlm6wflmk24x-lua-resty-http",
  "sha256": "1whwn2fwm8c9jda4z1sb5636sfy4pfgjdxw0grcgmf6451xi57nw",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/ledgetech/lua-resty-http";
    description = "Lua HTTP client cosocket driver for OpenResty / ngx_lua.";
    license.fullName = "2-clause BSD";
  };
}) {};

lua-resty-jwt = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, lua-resty-openssl
}:
buildLuarocksPackage {
  pname = "lua-resty-jwt";
  version = "0.2.3-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-resty-jwt-0.2.3-0.rockspec";
    sha256 = "1fxdwfr4pna3fdfm85kin97n53caq73h807wjb59wpqiynbqzc8c";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/cdbattags/lua-resty-jwt",
  "rev": "b3d5c085643fa95099e72a609c57095802106ff9",
  "date": "2021-01-20T16:53:57-05:00",
  "path": "/nix/store/z4a8ffxj2i3gbjp0f8r377cdp88lkzl4-lua-resty-jwt",
  "sha256": "07w8r8gqbby06x493qzislig7a3giw0anqr4ivp3g2ms8v9fnng6",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua-resty-openssl ];

  meta = {
    homepage = "https://github.com/cdbattags/lua-resty-jwt";
    description = "JWT for ngx_lua and LuaJIT.";
    license.fullName = "Apache License Version 2";
  };
}) {};

lua-resty-openidc = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, lua-resty-http, lua-resty-session, lua-resty-jwt
}:
buildLuarocksPackage {
  pname = "lua-resty-openidc";
  version = "1.7.4-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-resty-openidc-1.7.4-1.rockspec";
    sha256 = "12r03pzx1lpaxzy71iqh0kf1zs6gx1k89vpxc5va9r7nr47a56vy";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/zmartzone/lua-resty-openidc",
  "rev": "0c75741b41bc9a8b5dbe0b27f81a2851a6c68b60",
  "date": "2020-11-17T17:42:16+01:00",
  "path": "/nix/store/240kss5xx1br5n3qz6djw21cs1fj4pfg-lua-resty-openidc",
  "sha256": "1gw71av1r0c6v4f1h0bj0l6way2hmipic6wmipnavr17bz7m1q7z",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua-resty-http lua-resty-session lua-resty-jwt ];

  meta = {
    homepage = "https://github.com/zmartzone/lua-resty-openidc";
    description = "A library for NGINX implementing the OpenID Connect Relying Party (RP) and the OAuth 2.0 Resource Server (RS) functionality";
    license.fullName = "Apache 2.0";
  };
}) {};

lua-resty-openssl = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit}:
buildLuarocksPackage {
  pname = "lua-resty-openssl";
  version = "0.7.5-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-resty-openssl-0.7.5-1.rockspec";
    sha256 = "13v14in9cgmjgarmy6br9629ns1qlhw7a30c061y6gncjannnv6y";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/fffonion/lua-resty-openssl.git",
  "rev": "6a7f4a1649da7e0499b542b73c61e8dbdf91f57e",
  "date": "2021-09-18T06:15:54+08:00",
  "path": "/nix/store/01bninsbgix30zl97lk0p10ycqkc37kx-lua-resty-openssl",
  "sha256": "1ypji678lna9z3a48lhxs7wrw8d1prln7yfvqfm96lbmfvr5wfxw",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;


  meta = {
    homepage = "https://github.com/fffonion/lua-resty-openssl";
    description = "No summary";
    license.fullName = "BSD";
  };
}) {};

lua-resty-session = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lua-resty-session";
  version = "3.8-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-resty-session-3.8-1.rockspec";
    sha256 = "0pz86bshawysmsnfc5q1yh13gr1458j2nh8r93a4rrmk1wggc4ka";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/bungle/lua-resty-session.git",
  "rev": "2cd1f8484fdd429505ac33abf7a44adda1f367bf",
  "date": "2021-01-04T14:02:41+02:00",
  "path": "/nix/store/jqc8arr46mx1xbmrsw503zza1kmz7mcv-lua-resty-session",
  "sha256": "09q8xbxkr431i2k21vdyx740rv325v0zmnx0qa3q9x15kcfsd2fm",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/bungle/lua-resty-session";
    description = "Session Library for OpenResty – Flexible and Secure";
    license.fullName = "BSD";
  };
}) {};

lua-term = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl}:
buildLuarocksPackage {
  pname = "lua-term";
  version = "0.7-1";
  knownRockspec = (fetchurl {
    url    = "https://luafr.org/luarocks/lua-term-0.7-1.rockspec";
    sha256 = "0r9g5jw7pqr1dyj6w58dqlr7y7l0jp077n8nnji4phf10biyrvg2";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/hoelzro/lua-term/archive/0.07.tar.gz";
    sha256 = "0c3zc0cl3a5pbdn056vnlan16g0wimv0p9bq52h7w507f72x18f1";
  };


  meta = {
    homepage = "https://github.com/hoelzro/lua-term";
    description = "Terminal functions for Lua";
    license.fullName = "MIT/X11";
  };
}) {};

lua-toml = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lua-toml";
  version = "2.0-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-toml-2.0-1.rockspec";
    sha256 = "0zd3hrj1ifq89rjby3yn9y96vk20ablljvqdap981navzlbb7zvq";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/jonstoler/lua-toml.git",
  "rev": "13731a5dd48c8c314d2451760604810bd6221085",
  "date": "2017-12-08T16:30:50-08:00",
  "path": "/nix/store/cnpflpyj441c65jhb68hjr2bcvnj9han-lua-toml",
  "sha256": "0lklhgs4n7gbgva5frs39240da1y4nwlx6yxaj3ix6r5lp9sh07b",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/jonstoler/lua-toml";
    description = "toml decoder/encoder for Lua";
    license.fullName = "MIT";
  };
}) {};

lua-yajl = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lua-yajl";
  version = "2.0-1";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lua-yajl-2.0-1.rockspec";
    sha256 = "0h600zgq5qc9z3cid1kr35q3qb98alg0m3qf0a3mfj33hya6pcxp";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/brimworks/lua-yajl.git",
  "rev": "c0b598a70966b6cabc57a110037faf9091436f30",
  "date": "2020-11-12T06:22:23-08:00",
  "path": "/nix/store/9acgxpqk52kwn03m5xasn4f6mmsby2r9-lua-yajl",
  "sha256": "1frry90y7vqnw1rd1dfnksilynh0n24gfhkmjd6wwba73prrg0pf",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/brimworks/lua-yajl";
    description = "Integrate the yajl JSON library with Lua.";
    maintainers = with lib.maintainers; [ pstn ];
    license.fullName = "MIT/X11";
  };
}) {};

lua-zlib = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lua-zlib";
  version = "1.2-1";
  knownRockspec = (fetchurl {
    url    = "https://luafr.org/luarocks/lua-zlib-1.2-1.rockspec";
    sha256 = "18rpbg9b4vsnh3svapiqrvwwshw1abb5l5fd7441byx1nm3fjq9w";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/brimworks/lua-zlib.git",
  "rev": "a305d98f473d0a253b6fd740ce60d7d5a5f1cda0",
  "date": "2017-10-07T08:26:37-07:00",
  "path": "/nix/store/6hjfczd3xkilkdxidgqzdrwmaiwnlf05-lua-zlib",
  "sha256": "1cv12s5c5lihmf3hb0rz05qf13yihy1bjpb7448v8mkiss6y1s5c",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/brimworks/lua-zlib";
    description = "Simple streaming interface to zlib for Lua.";
    maintainers = with lib.maintainers; [ koral ];
    license.fullName = "MIT";
  };
}) {};

lua_cliargs = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "lua_cliargs";
  version = "3.0-2";

  src = fetchurl {
    url    = "https://github.com/amireh/lua_cliargs/archive/v3.0-2.tar.gz";
    sha256 = "0vhpgmy9a8wlxp8a15pnfqfk0aj7pyyb5m41nnfxynx580a6y7cp";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/amireh/lua_cliargs";
    description = "A command-line argument parser.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

luabitop = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "luabitop";
  version = "1.0.2-3";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/teto/luabitop.git",
  "rev": "8d7b674386460ca83e9510b3a8a4481344eb90ad",
  "date": "2021-08-30T10:14:03+02:00",
  "path": "/nix/store/sdnza0zpmlkz9jppnysasbvqy29f4zia-luabitop",
  "sha256": "1b57f99lrjbwsi4m23cq5kpj0dbpxh3xwr0mxs2rzykr2ijpgwrw",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.3");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://bitop.luajit.org/";
    description = "Lua Bit Operations Module";
    license.fullName = "MIT/X license";
  };
}) {};

luacheck = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, argparse, luafilesystem
}:
buildLuarocksPackage {
  pname = "luacheck";
  version = "0.25.0-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luacheck-0.25.0-1.rockspec";
    sha256 = "11mvbpnykibg0dx9sdh5x9gpvrhkmvrw76qvjz337x83f8gmvy91";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/luarocks/luacheck.git",
  "rev": "abf7386a892df4ce566fef9e4640ddbf9af78411",
  "date": "2021-08-10T12:19:20-03:00",
  "path": "/nix/store/9cdlf6c3y0087qwh48ky8ysxxx3lirlj-luacheck",
  "sha256": "1ymfkr0qmg6idrrxf9x6mfq14skag8h09kl2qlalwiykicrdljs1",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua argparse luafilesystem ];

  meta = {
    homepage = "https://github.com/luarocks/luacheck";
    description = "A static analyzer and a linter for Lua";
    license.fullName = "MIT";
  };
}) {};

luacov = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "luacov";
  version = "0.15.0-1";
  knownRockspec = (fetchurl {
    url    = "https://luafr.org/luarocks/luacov-0.15.0-1.rockspec";
    sha256 = "18byfl23c73pazi60hsx0vd74hqq80mzixab76j36cyn8k4ni9db";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/luacov.git",
  "rev": "19b52ca0298c8942df82dd441d7a4a588db4c413",
  "date": "2021-02-15T18:47:58-03:00",
  "path": "/nix/store/9vm38il9knzx2m66m250qj1fzdfzqg0y-luacov",
  "sha256": "08550nna6qcb5jn6ds1hjm6010y8973wx4qbf9vrvrcn1k2yr6ki",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://keplerproject.github.io/luacov/";
    description = "Coverage analysis tool for Lua scripts";
    license.fullName = "MIT";
  };
}) {};

luadbi = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "luadbi";
  version = "0.7.2-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luadbi-0.7.2-1.rockspec";
    sha256 = "0lj1qki20w6bl76cvlcazlmwh170b9wkv5nwlxbrr3cn6w7h370b";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mwild1/luadbi",
  "rev": "73a234c4689e4f87b7520276b6159cc7f6cfd6e0",
  "date": "2019-01-14T09:39:17+00:00",
  "path": "/nix/store/a3qgawila4r4jc2lpdc4mwyzd1gvzazd-luadbi",
  "sha256": "167ivwmczhp98bxzpz3wdxcfj6vi0a10gpi7rdfjs2rbfwkzqvjh",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-mysql = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, luadbi
}:
buildLuarocksPackage {
  pname = "luadbi-mysql";
  version = "0.7.2-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luadbi-mysql-0.7.2-1.rockspec";
    sha256 = "0gnyqnvcfif06rzzrdw6w6hchp4jrjiwm0rmfx2r8ljchj2bvml5";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mwild1/luadbi",
  "rev": "73a234c4689e4f87b7520276b6159cc7f6cfd6e0",
  "date": "2019-01-14T09:39:17+00:00",
  "path": "/nix/store/a3qgawila4r4jc2lpdc4mwyzd1gvzazd-luadbi",
  "sha256": "167ivwmczhp98bxzpz3wdxcfj6vi0a10gpi7rdfjs2rbfwkzqvjh",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-postgresql = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, luadbi
}:
buildLuarocksPackage {
  pname = "luadbi-postgresql";
  version = "0.7.2-1";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/luadbi-postgresql-0.7.2-1.rockspec";
    sha256 = "07rx4agw4hjyzf8157apdwfqh9s26nqndmkr3wm7v09ygjvdjiix";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mwild1/luadbi",
  "rev": "73a234c4689e4f87b7520276b6159cc7f6cfd6e0",
  "date": "2019-01-14T09:39:17+00:00",
  "path": "/nix/store/a3qgawila4r4jc2lpdc4mwyzd1gvzazd-luadbi",
  "sha256": "167ivwmczhp98bxzpz3wdxcfj6vi0a10gpi7rdfjs2rbfwkzqvjh",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-sqlite3 = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, luadbi
}:
buildLuarocksPackage {
  pname = "luadbi-sqlite3";
  version = "0.7.2-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luadbi-sqlite3-0.7.2-1.rockspec";
    sha256 = "022iba0jbiafz8iv1h0iv95rhcivbfq5yg341nxk3dm87yf220vh";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mwild1/luadbi",
  "rev": "73a234c4689e4f87b7520276b6159cc7f6cfd6e0",
  "date": "2019-01-14T09:39:17+00:00",
  "path": "/nix/store/a3qgawila4r4jc2lpdc4mwyzd1gvzazd-luadbi",
  "sha256": "167ivwmczhp98bxzpz3wdxcfj6vi0a10gpi7rdfjs2rbfwkzqvjh",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luaepnf = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, lpeg
}:
buildLuarocksPackage {
  pname = "luaepnf";
  version = "0.3-2";
  knownRockspec = (fetchurl {
    url    = "https://luafr.org/luarocks/luaepnf-0.3-2.rockspec";
    sha256 = "0kqmnj11wmfpc9mz04zzq8ab4mnbkrhcgc525wrq6pgl3p5li8aa";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/siffiejoe/lua-luaepnf.git",
  "rev": "4e0a867ff54cf424e1558781f5d2c85d2dc2137c",
  "date": "2015-01-15T16:54:10+01:00",
  "path": "/nix/store/n7gb0z26sl7dzdyy3bx1y3cz3npsna7d-lua-luaepnf",
  "sha256": "1lvsi3fklhvz671jgg0iqn0xbkzn9qjcbf2ks41xxjz3lapjr6c9",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua lpeg ];

  meta = {
    homepage = "http://siffiejoe.github.io/lua-luaepnf/";
    description = "Extended PEG Notation Format (easy grammars for LPeg)";
    license.fullName = "MIT";
  };
}) {};

luaevent = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luaevent";
  version = "0.4.6-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luaevent-0.4.6-1.rockspec";
    sha256 = "03zixadhx4a7nh67n0sm6sy97c8i9va1a78hibhrl7cfbqc2zc7f";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/harningt/luaevent/archive/v0.4.6.tar.gz";
    sha256 = "0pbh315d3p7hxgzmbhphkcldxv2dadbka96131b8j5914nxvl4nx";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/harningt/luaevent";
    description = "libevent binding for Lua";
    license.fullName = "MIT";
  };
}) {};

luaexpat = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luaexpat";
  version = "1.3.0-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luaexpat-1.3.0-1.rockspec";
    sha256 = "14f7y2acycbgrx95w3darx5l1qm52a09f7njkqmhyk10w615lrw4";
  }).outPath;
  src = fetchurl {
    url    = "http://matthewwild.co.uk/projects/luaexpat/luaexpat-1.3.0.tar.gz";
    sha256 = "1hvxqngn0wf5642i5p3vcyhg3pmp102k63s9ry4jqyyqc1wkjq6h";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.keplerproject.org/luaexpat/";
    description = "XML Expat parsing";
    maintainers = with lib.maintainers; [ arobyn flosse ];
    license.fullName = "MIT/X11";
  };
}) {};

luaffi = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "luaffi";
  version = "scm-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaffi-scm-1.rockspec";
    sha256 = "1nia0g4n1yv1sbv5np572y8yfai56a8bnscir807s5kj5bs0xhxm";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/facebook/luaffifb.git",
  "rev": "a1cb731b08c91643b0665935eb5622b3d621211b",
  "date": "2021-03-01T11:46:30-05:00",
  "path": "/nix/store/6dwfn64p3clcsxkq41b307q8izi0fvji-luaffifb",
  "sha256": "0nj76fw3yi57vfn35yvbdmpdbg9gmn5j1gw84ajs9w1j86sc0661",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/facebook/luaffifb";
    description = "FFI library for calling C functions from lua";
    license.fullName = "BSD";
  };
}) {};

luafilesystem = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "luafilesystem";
  version = "1.7.0-2";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luafilesystem-1.7.0-2.rockspec";
    sha256 = "0xivgn8bbkx1g5a30jrjcv4hg5mpiiyrm3fhlz9lndgbh4cnjrq6";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/luafilesystem",
  "rev": "de87218e9798c4dd1a40d65403d99e9e82e1cfa0",
  "date": "2017-09-15T20:07:33-03:00",
  "path": "/nix/store/20xm4942kvnb8kypg76jl7zrym5cz03c-luafilesystem",
  "sha256": "0zmprgkm9zawdf9wnw0v3w6ibaj442wlc6alp39hmw610fl4vghi",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "git://github.com/keplerproject/luafilesystem";
    description = "File System Library for the Lua Programming Language";
    maintainers = with lib.maintainers; [ flosse ];
    license.fullName = "MIT/X11";
  };
}) {};

lualogging = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, luasocket
}:
buildLuarocksPackage {
  pname = "lualogging";
  version = "1.5.2-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lualogging-1.5.2-1.rockspec";
    sha256 = "0jlqjhr5p9ji51bkmz8n9jc55i3vzqjfwjxvxp2ib9h4gmh2zqk3";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/lualogging.git",
  "rev": "8b4d8dd5a311245a197890405ba9324b9f5f5ab1",
  "date": "2021-08-12T19:29:39+02:00",
  "path": "/nix/store/q1v28n04hh3r7aw37cxakzksfa3kw5qa-lualogging",
  "sha256": "0nj0ik91lgl9rwgizdkn7vy9brddsz1kxfn70c01x861vaxi63iz",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  propagatedBuildInputs = [ luasocket ];

  meta = {
    homepage = "https://github.com/lunarmodules/lualogging";
    description = "A simple API to use logging features";
    license.fullName = "MIT/X11";
  };
}) {};

luaossl = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luaossl";
  version = "20200709-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luaossl-20200709-0.rockspec";
    sha256 = "0izxxrzc49q4jancza43b2y4hfvasflpcag771nrhapk1n8k45f3";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/wahern/luaossl/archive/rel-20200709.zip";
    sha256 = "07j1rqqypjb24x11x6v6qpwf12g0ib23qwg47sw3c2yqkbq744j4";
  };

  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://25thandclement.com/~william/projects/luaossl.html";
    description = "Most comprehensive OpenSSL module in the Lua universe.";
    license.fullName = "MIT/X11";
  };
}) {};

luaposix = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, bit32, lua
}:
buildLuarocksPackage {
  pname = "luaposix";
  version = "34.1.1-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luaposix-34.1.1-1.rockspec";
    sha256 = "0hx6my54axjcb3bklr991wji374qq6mwa3ily6dvb72vi2534nwz";
  }).outPath;
  src = fetchurl {
    url    = "http://github.com/luaposix/luaposix/archive/v34.1.1.zip";
    sha256 = "1xqx764ji054jphxdhkynsmwzqzkfgxqfizxkf70za6qfrvnl3yh";
  };

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ bit32 lua ];

  meta = {
    homepage = "http://github.com/luaposix/luaposix/";
    description = "Lua bindings for POSIX";
    maintainers = with lib.maintainers; [ vyp lblasc ];
    license.fullName = "MIT/X11";
  };
}) {};

luarepl = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luarepl";
  version = "0.9-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luarepl-0.9-1.rockspec";
    sha256 = "1409lanxv4s8kq5rrh46dvld77ip33qzfn3vac3i9zpzbmgb5i8z";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/hoelzro/lua-repl/archive/0.9.tar.gz";
    sha256 = "04xka7b84d9mrz3gyf8ywhw08xp65v8jrnzs8ry8k9540aqs721w";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/hoelzro/lua-repl";
    description = "A reusable REPL component for Lua, written in Lua";
    license.fullName = "MIT/X11";
  };
}) {};

luasec = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, luasocket
}:
buildLuarocksPackage {
  pname = "luasec";
  version = "1.0.2-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luasec-1.0.2-1.rockspec";
    sha256 = "02qkbfnvn3943zf2fnz3amnz1z05ipx9mnsn3i2rmpjpvvd414dg";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/brunoos/luasec",
  "rev": "ef14b27a2c8e541cac071165048250e85a7216df",
  "date": "2021-08-14T10:28:09-03:00",
  "path": "/nix/store/jk2npg54asnmj5fnpldn8dxym9gx8x4g-luasec",
  "sha256": "14hx72qw3gjgz12v5bwpz3irgbf69f8584z8y7lglccbyydp4jla",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua luasocket ];

  meta = {
    homepage = "https://github.com/brunoos/luasec/wiki";
    description = "A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket.";
    maintainers = with lib.maintainers; [ flosse ];
    license.fullName = "MIT";
  };
}) {};

luasocket = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luasocket";
  version = "3.0rc1-2";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/luasocket-3.0rc1-2.rockspec";
    sha256 = "17fbkihp4zypv5wwgxz8dnghj37pf5bhpi2llg4gbljp1bl2f42c";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/diegonehab/luasocket/archive/v3.0-rc1.zip";
    sha256 = "0x0fg07cg08ybgkpzif7zmzaaq5ga979rxwd9rj95kfws9bbrl0y";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://luaforge.net/projects/luasocket/";
    description = "Network support for the Lua language";
    license.fullName = "MIT";
  };
}) {};

luasql-sqlite3 = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "luasql-sqlite3";
  version = "2.6.0-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luasql-sqlite3-2.6.0-1.rockspec";
    sha256 = "0w32znsfcaklcja6avqx7daaxbf0hr2v8g8bmz0fysb3401lmp02";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/luasql.git",
  "rev": "ce22164f63783afac9c644fd37c231e56fc097cb",
  "date": "2021-10-14T09:38:24-03:00",
  "path": "/nix/store/h8r8axcc76x7y6gwc2jzsmr7h2lqgbxa-luasql",
  "sha256": "10gq3x7vqkafvfk9fs4039rl1xhnqpl2v60z4qpd96wbcy205gnk",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.keplerproject.org/luasql/";
    description = "Database connectivity for Lua (SQLite3 driver)";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

luassert = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua, say
}:
buildLuarocksPackage {
  pname = "luassert";
  version = "1.8.0-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luassert-1.8.0-0.rockspec";
    sha256 = "1194y81nlkq4qmrrgl7z82i6vgvhqvp1p673kq0arjix8mv3zyz1";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/Olivine-Labs/luassert/archive/v1.8.0.tar.gz";
    sha256 = "0xlwlb32215524bg33svp1ci8mdvh9wykchl8dkhihpxcd526mar";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua say ];

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description = "Lua Assertions Extension";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

luasystem = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luasystem";
  version = "0.2.1-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luasystem-0.2.1-0.rockspec";
    sha256 = "0xj5q7lzsbmlw5d3zbjqf3jpj78wcn348h2jcxn5ph4n4hx73z3n";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/o-lim/luasystem/archive/v0.2.1.tar.gz";
    sha256 = "150bbklchh02gsvpngv56xrrlxxvwpqwrh0yy6z95fnvks7gd0qb";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://olivinelabs.com/luasystem/";
    description = "Platform independent system calls for Lua.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

luautf8 = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luautf8";
  version = "0.1.3-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luautf8-0.1.3-1.rockspec";
    sha256 = "16i9wfgd0f299g1afgjp0hhczlrk5g8i0kq3ka0f8bwj3mp2wmcp";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/starwing/luautf8/archive/0.1.3.tar.gz";
    sha256 = "02rf8jmazmi8rp3i5v4jsz0d7mrf1747qszsl8i2hv1sl0ik92r0";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/starwing/luautf8";
    description = "A UTF-8 support module for Lua";
    maintainers = with lib.maintainers; [ pstn ];
    license.fullName = "MIT";
  };
}) {};

luazip = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "luazip";
  version = "1.2.7-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luazip-1.2.7-1.rockspec";
    sha256 = "1wxy3p2ksaq4s8lg925mi9cvbh875gsapgkzm323dr8qaxxg7mba";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mpeterv/luazip",
  "rev": "e424f667cc5c78dd19bb5eca5a86b3c8698e0ce5",
  "date": "2017-09-05T14:02:52+03:00",
  "path": "/nix/store/idllj442c0iwnx1cpkrifx2afb7vh821-luazip",
  "sha256": "1jlqzqlds3aa3hnp737fm2awcx0hzmwyd87klv0cv13ny5v9f2x4",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mpeterv/luazip";
    description = "Library for reading files inside zip files";
    license.fullName = "MIT";
  };
}) {};

luuid = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luuid";
  version = "20120509-2";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luuid-20120509-2.rockspec";
    sha256 = "1q2fv25wfbiqn49mqv26gs4pyllch311akcf7jjn27l5ik8ji5b6";
  }).outPath;
  src = fetchurl {
    url    = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.2/luuid.tar.gz";
    sha256 = "1bfkj613d05yps3fivmz0j1bxf2zkg9g1yl0ifffgw0vy00hpnvm";
  };

  disabled = with lua; (luaOlder "5.2") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#luuid";
    description = "A library for UUID generation";
    license.fullName = "Public domain";
  };
}) {};

luv = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luv";
  version = "1.42.0-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luv-1.42.0-0.rockspec";
    sha256 = "0pr2gjjnm60w0csb0dacrjalan7ifsfw4lki4ykxx1f4m5snam09";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/luvit/luv/releases/download/1.42.0-0/luv-1.42.0-0.tar.gz";
    sha256 = "0dkzjkkm0h516ag6sfz5iji761y9slrcfw325f39zkda1sfql8mm";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/luvit/luv";
    description = "Bare libuv bindings for lua";
    license.fullName = "Apache 2.0";
  };
}) {};

lyaml = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "lyaml";
  version = "6.2.7-1";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lyaml-6.2.7-1.rockspec";
    sha256 = "0m5bnzg24nyk35gcn4rydgzk0ysk1f6rslxwxd0w3drl1bg64zja";
  }).outPath;
  src = fetchurl {
    url    = "http://github.com/gvvaughan/lyaml/archive/v6.2.7.zip";
    sha256 = "165mr3krf8g8070j4ax9z0j2plfbdwb8x2zk2hydpqaqa0kcdb0c";
  };

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/gvvaughan/lyaml";
    description = "libYAML binding for Lua";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT/X11";
  };
}) {};

markdown = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "markdown";
  version = "0.33-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/markdown-0.33-1.rockspec";
    sha256 = "02sixijfi6av8h59kx3ngrhygjn2sx1c85c0qfy20gxiz72wi1pl";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mpeterv/markdown",
  "rev": "8c09109924b218aaecbfd4d4b1de538269c4d765",
  "date": "2015-09-27T17:49:28+03:00",
  "path": "/nix/store/akl80hh077hm20bdqj1lksy0fn2285b5-markdown",
  "sha256": "019bk2qprszqncnm8zy6ns6709iq1nwkf7i86nr38f035j4lc11y",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mpeterv/markdown";
    description = "Markdown text-to-html markup system.";
    license.fullName = "MIT/X11";
  };
}) {};

mediator_lua = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "mediator_lua";
  version = "1.1.2-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/mediator_lua-1.1.2-0.rockspec";
    sha256 = "0frzvf7i256260a1s8xh92crwa2m42972qxfq29zl05aw3pyn7bm";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/Olivine-Labs/mediator_lua/archive/v1.1.2-0.tar.gz";
    sha256 = "16zzzhiy3y35v8advmlkzpryzxv5vji7727vwkly86q8sagqbxgs";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://olivinelabs.com/mediator_lua/";
    description = "Event handling through channels";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

moonscript = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, lpeg, alt-getopt, luafilesystem
}:
buildLuarocksPackage {
  pname = "moonscript";
  version = "0.5.0-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/moonscript-0.5.0-1.rockspec";
    sha256 = "06ykvmzndkcmbwn85a4l1cl8v8jw38g0isdyhwwbgv0m5a306j6d";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/leafo/moonscript.git",
  "rev": "b7efcd131046ed921ae1075d7c0f6a3b64a570f7",
  "date": "2021-03-18T11:51:52-07:00",
  "path": "/nix/store/xijbk0bgjpxjgmvscbqnghj4r3zdzgxl-moonscript",
  "sha256": "14xx6pij0djblfv3g2hi0xlljh7h0yrbb03f4x90q5j66v693gx7",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua lpeg alt-getopt luafilesystem ];

  meta = {
    homepage = "http://moonscript.org";
    description = "A programmer friendly language that compiles to Lua";
    maintainers = with lib.maintainers; [ arobyn ];
    license.fullName = "MIT";
  };
}) {};

mpack = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl}:
buildLuarocksPackage {
  pname = "mpack";
  version = "1.0.9-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/mpack-1.0.9-0.rockspec";
    sha256 = "1v10kmw3qw559bbm142z40ib26bwvcyi64qjrk0vf8v6n1mx8wcn";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.9/libmpack-lua-1.0.9.tar.gz";
    sha256 = "17lyjmnbychacwahqgs128nb00xky777g7zw5wf20vrzkiq7xl0g";
  };


  meta = {
    homepage = "https://github.com/libmpack/libmpack-lua";
    description = "Lua binding to libmpack";
    license.fullName = "MIT";
  };
}) {};

nvim-client = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua, mpack, luv, coxpcall
}:
buildLuarocksPackage {
  pname = "nvim-client";
  version = "0.2.2-1";

  src = fetchurl {
    url    = "https://github.com/neovim/lua-client/archive/0.2.2-1.tar.gz";
    sha256 = "1h736im524lq0vwlpihv9b317jarpkf3j13a25xl5qq8y8asm8mr";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua mpack luv coxpcall ];

  meta = {
    homepage = "https://github.com/neovim/lua-client";
    description = "Lua client to Nvim";
    license.fullName = "Apache";
  };
}) {};

penlight = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, luafilesystem
}:
buildLuarocksPackage {
  pname = "penlight";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/penlight.git",
  "rev": "0653cdb05591454a9804a7fee8c873b8f06b0b8f",
  "date": "2021-08-31T23:42:29+02:00",
  "path": "/nix/store/zf3k6z36bxsrbxkkmsa4w6m7vxvlpfgn-penlight",
  "sha256": "0l1819dyr9hzmimnjjg99fad6k3ksmlm77hgvdybgz8558lj4g1i",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua luafilesystem ];

  meta = {
    homepage = "https://lunarmodules.github.io/penlight";
    description = "Lua utility libraries loosely based on the Python standard libraries";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT/X11";
  };
}) {};

plenary-nvim = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, luassert
}:
buildLuarocksPackage {
  pname = "plenary.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/nvim-lua/plenary.nvim",
  "rev": "80bb2b9bb74bdca38a46480b6f2e15af990406e4",
  "date": "2021-10-06T19:20:08+02:00",
  "path": "/nix/store/mw4r562qxr7giy1n43iylp3qb8ch0jqs-plenary.nvim",
  "sha256": "11akcpxcp4m997a2y76ajknnmsifac2hj4nq9i4a8b1j08bxinim",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luassert ];

  meta = {
    homepage = "http://github.com/nvim-lua/plenary.nvim";
    description = "lua functions you don't want to write ";
    license.fullName = "MIT/X11";
  };
}) {};

rapidjson = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "rapidjson";
  version = "0.7.1-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/xpol/lua-rapidjson",
  "rev": "242b40c8eaceb0cc43bcab88309736461cac1234",
  "date": "2021-04-09T19:59:20+08:00",
  "path": "/nix/store/65l71ph27pmipgrq8j4whg6n8h2avvs4-lua-rapidjson",
  "sha256": "1a6srvximxlh6gjkaj5y86d1kf06pc4gby2r6wpdw2pdac8k7xyb",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/xpol/lua-rapidjson";
    description = "Json module based on the very fast RapidJSON.";
    license.fullName = "MIT";
  };
}) {};

readline = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua, luaposix
}:
buildLuarocksPackage {
  pname = "readline";
  version = "3.0-0";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/readline-3.0-0.rockspec";
    sha256 = "1bjj8yn61vc0fzy1lvrfp6cyakj4bf2255xcqai4h3rcg0i5cmpr";
  }).outPath;
  src = fetchurl {
    url    = "http://www.pjb.com.au/comp/lua/readline-3.0.tar.gz";
    sha256 = "1rr2b7q8w3i4bm1i634sd6kzhw6v1fpnh53mj09af6xdq1rfhr5n";
  };

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua luaposix ];

  meta = {
    homepage = "http://pjb.com.au/comp/lua/readline.html";
    description = "Interface to the readline library";
    license.fullName = "MIT/X11";
  };
}) {};

say = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "say";
  version = "1.3-1";

  src = fetchurl {
    url    = "https://github.com/Olivine-Labs/say/archive/v1.3-1.tar.gz";
    sha256 = "1jh76mxq9dcmv7kps2spwcc6895jmj2sf04i4y9idaxlicvwvs13";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description = "Lua String Hashing/Indexing Library";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

std-_debug = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "std._debug";
  version = "git-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lua-stdlib/_debug.git",
  "rev": "3236c1561bfc2724a3abd153a6e10c7957b35cf2",
  "date": "2020-04-15T16:34:01-07:00",
  "path": "/nix/store/rgbn0nn7glm7s52d90ds87j10bx20nij-_debug",
  "sha256": "0p6jz6syh2r8qfk08jf2hp4p902rkamjzpzl8xhkpzf8rdzs937w",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://lua-stdlib.github.io/_debug";
    description = "Debug Hints Library";
    license.fullName = "MIT/X11";
  };
}) {};

std-normalize = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, std-_debug
}:
buildLuarocksPackage {
  pname = "std.normalize";
  version = "git-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lua-stdlib/normalize.git",
  "rev": "fb1d61b88b03406e291f58ec4981edfc538b8216",
  "date": "2020-04-15T17:16:16-07:00",
  "path": "/nix/store/jr4agcn13fk56b8105p6yr9gn767fkds-normalize",
  "sha256": "0jiykdjxc4b5my12fnzrw3bxracjgxc265xrn8kfx95350kvbzl1",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua std-_debug ];

  meta = {
    homepage = "https://lua-stdlib.github.io/normalize";
    description = "Normalized Lua Functions";
    license.fullName = "MIT/X11";
  };
}) {};

stdlib = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "stdlib";
  version = "41.2.2-1";
  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/stdlib-41.2.2-1.rockspec";
    sha256 = "0rscb4cm8s8bb8fk8rknc269y7bjqpslspsaxgs91i8bvabja6f6";
  }).outPath;
  src = fetchurl {
    url    = "http://github.com/lua-stdlib/lua-stdlib/archive/release-v41.2.2.zip";
    sha256 = "0is8i8lk4qq4afnan0vj1bwr8brialyrva7cjy43alzgwdphwynx";
  };

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://lua-stdlib.github.io/lua-stdlib";
    description = "General Lua Libraries";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

vstruct = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "vstruct";
  version = "2.1.1-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/ToxicFrog/vstruct.git",
  "rev": "924d3dd63043189e4a7ef6b1b54b19208054cc0f",
  "date": "2020-05-06T23:13:06-04:00",
  "path": "/nix/store/a4i9k5hx9xiz38bij4hb505dg088jkss-vstruct",
  "sha256": "0sl9v874mckhh6jbxsan48s5xajzx193k4qlphw69sdbf8kr3p57",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/ToxicFrog/vstruct";
    description = "Lua library to manipulate binary data";
  };
}) {};


}
/* GENERATED - do not edit this file */
