/* pkgs/development/lua-modules/generated-packages.nix is an auto-generated file -- DO NOT EDIT!
Regenerate it with: nix run nixpkgs#update-luarocks-packages
You can customize the generated packages in pkgs/development/lua-modules/overrides.nix
*/

{ stdenv, lib, fetchurl, fetchgit, callPackage, ... } @ args:
final: prev:
{
alt-getopt = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "alt-getopt";
  version = "0.8.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/alt-getopt-0.8.0-1.rockspec";
    sha256 = "17yxi1lsrbkmwzcn1x48x8758d7v1frsz1bmnpqfv4vfnlh0x210";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/cheusov/lua-alt-getopt",
  "rev": "f495c21d6a203ab280603aa5799e636fb5651ae7",
  "date": "2017-01-06T13:50:55+03:00",
  "path": "/nix/store/z72v77cw9188408ynsppwhlzii2dr740-lua-alt-getopt",
  "sha256": "1kq7r5668045diavsqd1j6i9hxdpsk99w8q4zr8cby9y3ws4q6rv",
  "hash": "sha256-OxtMNB8++cVQ/gQjntLUt3WYopGhYb1VbIUAZEzJB88=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/cheusov/lua-alt-getopt";
    description = "Process application arguments the same way as getopt_long";
    maintainers = with lib.maintainers; [ arobyn ];
    license.fullName = "MIT/X11";
  };
}) {};

argparse = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "argparse";
  version = "0.7.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/argparse-0.7.1-1.rockspec";
    sha256 = "116iaczq6glzzin6qqa2zn7i22hdyzzsq6mzjiqnz6x1qmi0hig8";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/luarocks/argparse/archive/0.7.1.zip";
    sha256 = "0idg79d0dfis4qhbkbjlmddq87np75hb2vj41i6prjpvqacvg5v1";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/luarocks/argparse";
    description = "A feature-rich command-line argument parser";
    license.fullName = "MIT";
  };
}) {};

basexx = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "basexx";
  version = "0.4.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/basexx-0.4.1-1.rockspec";
    sha256 = "0kmydxm2wywl18cgj303apsx7hnfd68a9hx9yhq10fj7yfcxzv5f";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/aiq/basexx/archive/v0.4.1.tar.gz";
    sha256 = "1rnz6xixxqwy0q6y2hi14rfid4w47h69gfi0rnlq24fz8q2b0qpz";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/aiq/basexx";
    description = "A base2, base16, base32, base64 and base85 library for Lua";
    license.fullName = "MIT";
  };
}) {};

binaryheap = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "binaryheap";
  version = "0.4-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/binaryheap-0.4-1.rockspec";
    sha256 = "1ah37lhskmrb26by5ygs7jblx7qnf6mphgw8kwhw0yacvmkcbql4";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/Tieske/binaryheap.lua/archive/version_0v4.tar.gz";
    sha256 = "0f5l4nb5s7dycbkgh3rrl7pf0npcf9k6m2gr2bsn09fjyb3bdc8h";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/Tieske/binaryheap.lua";
    description = "Binary heap implementation in pure Lua";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT/X11";
  };
}) {};

bit32 = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "bit32";
  version = "5.3.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/bit32-5.3.0-1.rockspec";
    sha256 = "1d6xdihpksrj5a3yvsvnmf3vfk15hj6f8n1rrs65m7adh87hc0yd";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/lua-compat-5.2.git",
  "rev": "10c7d40943601eb1f80caa9e909688bb203edc4d",
  "date": "2015-02-17T10:44:04+01:00",
  "path": "/nix/store/9kz7kgjmq0w9plrpha866bmwsgp4rfhn-lua-compat-5.2",
  "sha256": "1ipqlbvb5w394qwhm2f3w6pdrgy8v4q8sps5hh3pqz14dcqwakhj",
  "hash": "sha256-Ek7FMWskfHwHhEVfjTDZyL/cruHDiQo5Jmnwsvai+MY=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.lua.org/manual/5.2/manual.html#6.7";
    description = "Lua 5.2 bit manipulation library";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT/X11";
  };
}) {};

busted = callPackage({ buildLuarocksPackage, dkjson, fetchgit, fetchurl, lua, lua-term, luaOlder, lua_cliargs, luassert, luasystem, mediator_lua, penlight, say }:
buildLuarocksPackage {
  pname = "busted";
  version = "2.2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/busted-2.2.0-1.rockspec";
    sha256 = "0h4zk4lcm40wg3l0vgjn6lsyh9yayhljx65a0pz5n99dxal8lgnf";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/busted.git",
  "rev": "02f31a9c103a44e166617cfdb6ba1b8994a9c912",
  "date": "2023-11-06T14:24:47+03:00",
  "path": "/nix/store/59a4spix6yw8lvkxq7q1fkdv0gfqd72k-busted",
  "sha256": "0pwyidy7l223ydsfbf5xsjqgyhm73942ks44d3bivh8ldam4zg74",
  "hash": "sha256-5LxPqmoUwR3XaIToKUgap0L/sNS9uOV080MIenyLnl8=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ dkjson lua lua-term lua_cliargs luassert luasystem mediator_lua penlight say ];

  meta = {
    homepage = "https://lunarmodules.github.io/busted/";
    description = "Elegant Lua unit testing";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

cassowary = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder, penlight }:
buildLuarocksPackage {
  pname = "cassowary";
  version = "2.3.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cassowary-2.3.2-1.rockspec";
    sha256 = "0c6sflm8zpgbcdj47s3rd34h69h3nqcciaaqd1wdx5m0lwc3mii0";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/sile-typesetter/cassowary.lua",
  "rev": "e33195f08438c15d725d283979165fda7c6c3321",
  "date": "2022-04-22T11:23:46+03:00",
  "path": "/nix/store/51mb376xh9pnh2krk08ljmy01zhr9y3z-cassowary.lua",
  "sha256": "1lvl40dhzmbqqjrqpjgqlg2kl993fpdy1mpc6d1610zpa9znx1f0",
  "hash": "sha256-wIVuf1L3g2BCM+zW4Nt1IyU6xaP4yYuzxHjVDxsgdNM=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua penlight ];

  meta = {
    homepage = "https://github.com/sile-typesetter/cassowary.lua";
    description = "The cassowary constraint solver";
    maintainers = with lib.maintainers; [ marsam alerque ];
    license.fullName = "Apache 2";
  };
}) {};

cldr = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder, penlight }:
buildLuarocksPackage {
  pname = "cldr";
  version = "0.3.0-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cldr-0.3.0-0.rockspec";
    sha256 = "1fnr8k713w21v7hc64s4w5lgcgnbphq3gm69pisc2s4wq2fkija1";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/alerque/cldr-lua.git",
  "rev": "4602a7859535ca198ddfaba73a02f9bce3e81025",
  "date": "2022-12-06T12:36:06+03:00",
  "path": "/nix/store/3xgwqd2pica8301sbfrw4bmv0xm2wzx5-cldr-lua",
  "sha256": "0hlfb115qhamczzskvckxczf9dpp8cv8h6vz7zgdl2n025ik9dp4",
  "hash": "sha256-5LY0YxHACtreP38biDZD97bkPuuT7an/Z1VBXEJYjkI=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua penlight ];

  meta = {
    homepage = "https://github.com/alerque/cldr-lua";
    description = "Lua interface to Unicode CLDR data";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT/ICU";
  };
}) {};

commons-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
buildLuarocksPackage {
  pname = "commons.nvim";
  version = "15.0.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/commons.nvim-15.0.0-1.rockspec";
    sha256 = "1f3izlp5jkr772pfbdm3q6qm5vmqqzdn4pl9qyq9fp9jzxrbv62r";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/linrongbin16/commons.nvim/archive/b50a5a220c25baa5d7568137451bdc8c3c08e80c.zip";
    sha256 = "1ylvrywms5igixmkpgk6kv3a8w6d4c17dzlca9av0xxxj7ny3vgq";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://linrongbin16.github.io/commons.nvim/";
    description = "The commons lua library for Neovim plugin project.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

compat53 = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "compat53";
  version = "0.12-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/compat53-0.12-1.rockspec";
    sha256 = "0ijp8ch3927rnj872l6cq79fd53dyfc2qg82y9b0g6kqs7cdl348";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/lunarmodules/lua-compat-5.3/archive/v0.12.zip";
    sha256 = "177zk7rww76wqxqsd2kxwfzb0nd7wfacm81vxwqsc84bfccsl3j4";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/lunarmodules/lua-compat-5.3";
    description = "Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT";
  };
}) {};

cosmo = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lpeg }:
buildLuarocksPackage {
  pname = "cosmo";
  version = "16.06.04-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cosmo-16.06.04-1.rockspec";
    sha256 = "0ipv1hrlhvaz1myz6qxabq7b7kb3bz456cya3r292487a3g9h9pb";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mascarenhas/cosmo.git",
  "rev": "e774f08cbf8d271185812a803536af8a8240ac51",
  "date": "2016-06-17T05:39:58-07:00",
  "path": "/nix/store/k3p4xc4cfihp4h8aj6vacr25rpcsjd96-cosmo",
  "sha256": "03b5gwsgxd777970d2h6rx86p7ivqx7bry8xmx2r396g3w85qy2p",
  "hash": "sha256-V3hcEB/PpJFFrx35vE7HO55rUM8GigZOOue0/jR/ZQ0=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  propagatedBuildInputs = [ lpeg ];

  meta = {
    homepage = "http://cosmo.luaforge.net";
    description = "Safe templates for Lua";
    maintainers = with lib.maintainers; [ marsam ];
    license.fullName = "MIT/X11";
  };
}) {};

coxpcall = callPackage({ buildLuarocksPackage, fetchgit, fetchurl }:
buildLuarocksPackage {
  pname = "coxpcall";
  version = "1.17.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/coxpcall-1.17.0-1.rockspec";
    sha256 = "0mf0nggg4ajahy5y1q5zh2zx9rmgzw06572bxx6k8b736b8j7gca";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/coxpcall",
  "rev": "ea22f44e490430e40217f0792bf82eaeaec51903",
  "date": "2018-02-26T19:53:11-03:00",
  "path": "/nix/store/1q4p5qvr6rlwisyarlgnmk4dx6vp8xdl-coxpcall",
  "sha256": "1k3q1rr2kavkscf99b5njxhibhp6iwhclrjk6nnnp233iwc2jvqi",
  "hash": "sha256-EW8pGI9jiGutNVNmyiCP5sIVYZe2rJQc03OrKXIOeMw=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;


  meta = {
    homepage = "http://keplerproject.github.io/coxpcall";
    description = "Coroutine safe xpcall and pcall";
    license.fullName = "MIT/X11";
  };
}) {};

cqueues = callPackage({ buildLuarocksPackage, fetchurl, lua }:
buildLuarocksPackage {
  pname = "cqueues";
  version = "20200726.51-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cqueues-20200726.51-0.rockspec";
    sha256 = "1y7dqvw75cj9ifn7cyhd98znaga4lksnbddcqmh512crawlf5sxv";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/wahern/cqueues/archive/rel-20200726.tar.gz";
    sha256 = "0lhd02ag3r1sxr2hx847rdjkddm04l1vf5234v5cz9bd4kfjw4cy";
  };

  disabled = (lua.luaversion != "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://25thandclement.com/~william/projects/cqueues.html";
    description = "Continuation Queues: Embeddable asynchronous networking, threading, and notification framework for Lua on Unix.";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT/X11";
  };
}) {};

cyan = callPackage({ argparse, buildLuarocksPackage, fetchgit, fetchurl, luafilesystem, tl }:
buildLuarocksPackage {
  pname = "cyan";
  version = "0.3.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cyan-0.3.0-1.rockspec";
    sha256 = "1bs5gwgdhibj2gm8y3810b0hh6s9n00fgij8nnjag9kpqrd80vsj";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/teal-language/cyan",
  "rev": "57650a3a0314a5e894c6ead30a5a52f7825f009c",
  "date": "2023-12-07T02:47:54-06:00",
  "path": "/nix/store/g3rqlf5cj06y2qqjlhkms51y4l142waf-cyan",
  "sha256": "0xww1p3l0rbm7xiyax37524zybgmbrsjkpvgg327w8yndqysidfd",
  "hash": "sha256-zbWoPW7WI37EeG/fKXVe9S3/iShndOVjP3VlQMcNnHc=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  propagatedBuildInputs = [ argparse luafilesystem tl ];

  meta = {
    homepage = "https://github.com/teal-language/cyan";
    description = "A build system for the Teal language";
    license.fullName = "MIT";
  };
}) {};

digestif = callPackage({ buildLuarocksPackage, fetchgit, lpeg, lua, luaOlder, luafilesystem }:
buildLuarocksPackage {
  pname = "digestif";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/astoff/digestif",
  "rev": "c0199f9cd86021c0a89662002d7a3411d12fb168",
  "date": "2023-03-10T15:04:26+01:00",
  "path": "/nix/store/3s849fwc80lf7pvgsiavqmvc5538cwwd-digestif",
  "sha256": "0xccrrfwvcj03nnrzs3iwig7y2ahl706h413hkywcplyd5407dv9",
  "hash": "sha256-abcDSGmeXsb9hCMQaMChUAl/XuRx6J+tHUCyzV3OjHU=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.3");
  propagatedBuildInputs = [ lpeg lua luafilesystem ];

  meta = {
    homepage = "https://github.com/astoff/digestif/";
    description = "A code analyzer for TeX";
    license.fullName = "GPLv3+ and other free licenses";
  };
}) {};

dkjson = callPackage({ buildLuarocksPackage, fetchurl, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "dkjson";
  version = "2.6-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/dkjson-2.6-1.rockspec";
    sha256 = "1hhmgz2nixqg23shfnl0kq6wxdadx36z6hhsrz33g7idbm6rbwm1";
  }).outPath;
  src = fetchurl {
    url    = "http://dkolf.de/src/dkjson-lua.fsl/tarball/dkjson-2.6.tar.gz?uuid=release_2_6";
    sha256 = "0wwpdz20fvg5j36902892mnb99craf22697r6v7xdblqnd7fw1xx";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://dkolf.de/src/dkjson-lua.fsl/";
    description = "David Kolf's JSON module for Lua";
    license.fullName = "MIT/X11";
  };
}) {};

fennel = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "fennel";
  version = "1.4.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/fennel-1.4.0-1.rockspec";
    sha256 = "1ldbcrzap8ajgwmxf70g0nw7sjdpabba56y2lg3z4hpnxccpb80n";
  }).outPath;
  src = fetchurl {
    url    = "https://fennel-lang.org/downloads/fennel-1.4.0.tar.gz";
    sha256 = "0g1lzkpmzhvhkc08kmn48k3m02pkcwgslz29fb23apbhydkavlx2";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://fennel-lang.org/";
    description = "A lisp that compiles to Lua";
    maintainers = with lib.maintainers; [ misterio77 ];
    license.fullName = "MIT";
  };
}) {};

fidget-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
buildLuarocksPackage {
  pname = "fidget.nvim";
  version = "1.1.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/fidget.nvim-1.1.0-1.rockspec";
    sha256 = "0pgjbsqp6bs9kwi0qphihwhl47j1lzdgg3xfa6msikrcf8d7j0hf";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/j-hui/fidget.nvim/archive/300018af4abd00610a345e382ca1f4b7ba420f77.zip";
    sha256 = "0bwjcqkb735wqnzc8rngvpq1b2rxgc7m0arjypvnvzsxw6wd1f61";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/j-hui/fidget.nvim";
    description = "Extensible UI for Neovim notifications and LSP progress messages.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

fifo = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua }:
buildLuarocksPackage {
  pname = "fifo";
  version = "0.2-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/fifo-0.2-0.rockspec";
    sha256 = "0vr9apmai2cyra2n573nr3dyk929gzcs4nm1096jdxcixmvh2ymq";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/daurnimator/fifo.lua/archive/0.2.zip";
    sha256 = "1800k7h5hxsvm05bjdr65djjml678lwb0661cll78z1ys2037nzn";
  };

  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/daurnimator/fifo.lua";
    description = "A lua library/'class' that implements a FIFO";
    license.fullName = "MIT/X11";
  };
}) {};

fluent = callPackage({ buildLuarocksPackage, cldr, fetchgit, fetchurl, lua, luaOlder, luaepnf, penlight }:
buildLuarocksPackage {
  pname = "fluent";
  version = "0.2.0-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/fluent-0.2.0-0.rockspec";
    sha256 = "1x3nk8xdf923rvdijr0jx8v6w3wxxfch7ri3kxca0pw80b5bc2fa";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/alerque/fluent-lua.git",
  "rev": "e1cd4130e460bcd52f9118b7d9f9a72d2e8b902c",
  "date": "2022-04-16T23:08:20+03:00",
  "path": "/nix/store/flxlnrzg6rx75qikiggmy494npx59p0b-fluent-lua",
  "sha256": "12js8l4hcxhziza0sry0f01kfm8f8m6kx843dmcky36z1y2mccmq",
  "hash": "sha256-uDJWhQ/fDD9ZbYOgPk1FDlU3A3DAZw3Ujx92BglFWoo=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ cldr lua luaepnf penlight ];

  meta = {
    homepage = "https://github.com/alerque/fluent-lua";
    description = "Lua implementation of Project Fluent";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT";
  };
}) {};

funnyfiles-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
buildLuarocksPackage {
  pname = "funnyfiles.nvim";
  version = "1.0.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/funnyfiles.nvim-1.0.1-1.rockspec";
    sha256 = "1r3cgx8wvc1c4syk167m94ws513g0cdmmxnymf3zyidlszdwamy5";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/aikooo7/funnyfiles.nvim/archive/v1.0.1.zip";
    sha256 = "00p026r05gldbf18mmv8da9ap09di8dhy0rrd586pr2s2s36nzpd";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/aikooo7/funnyfiles.nvim";
    description = "This plugin is a way of creating/deleting files/folders without needing to open a file explorer.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

fzf-lua = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
buildLuarocksPackage {
  pname = "fzf-lua";
  version = "0.0.1195-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/fzf-lua-0.0.1195-1.rockspec";
    sha256 = "1bcjis9mkbzq7178fkpqkafs6656bhvq1wh13vm1r3khbvi0jkp1";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/ibhagwan/fzf-lua/archive/0c884bb24ab0fef204f315f34e711b13ece0ea9f.zip";
    sha256 = "04gif5hyb6qzh649xzcwzx81rlrk2glking05q8wxp2cpa3nifpw";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/ibhagwan/fzf-lua";
    description = "Improved fzf.vim written in lua";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "AGPL-3.0";
  };
}) {};

fzy = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "fzy";
  version = "1.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/fzy-1.0-1.rockspec";
    sha256 = "1v050lm3rn1k5wwi2nimlbp1b7j6b8vkwvhc1npyqzj8jv7w9w9n";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/swarn/fzy-lua",
  "rev": "2d018a56e3a240bca4b3142a723b2f56392f3e4a",
  "date": "2023-01-29T07:05:02-06:00",
  "path": "/nix/store/nz19glmy52jbz46wl7xf0jd8m441klf0-fzy-lua",
  "sha256": "0xknm5513a6nlariwxgqndf3wj8xals26swjsv06hx133ihna01x",
  "hash": "sha256-PQBlYRwjdGjA1pJrIzRVHUk+XLP4dR6zotaoEUqpdnY=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/swarn/fzy-lua";
    description = "A fuzzy string-matching algorithm";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

gitsigns-nvim = callPackage({ buildLuarocksPackage, fetchgit, lua }:
buildLuarocksPackage {
  pname = "gitsigns.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lewis6991/gitsigns.nvim",
  "rev": "6ef8c54fb526bf3a0bc4efb0b2fe8e6d9a7daed2",
  "date": "2023-11-29T12:07:41+00:00",
  "path": "/nix/store/2ihnjknz2xdwsijjimqk8i3pi9cbpvhf-gitsigns.nvim",
  "sha256": "086jmhzgpavwjvp7ssd8ga0wxgnz480zzjiv84h4ivva2nv3lnvi",
  "hash": "sha256-cVs6thVq70ggQTvK/wEi377OgXqoaX3ulnyr+z6s0iA=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (lua.luaversion != "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/lewis6991/gitsigns.nvim";
    description = "Git signs written in pure lua";
    license.fullName = "MIT/X11";
  };
}) {};

haskell-tools-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
buildLuarocksPackage {
  pname = "haskell-tools.nvim";
  version = "3.0.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/haskell-tools.nvim-3.0.2-1.rockspec";
    sha256 = "1gls4dc4b8p0827jsvzf1n3gxfmqn1r7n8hi1rnfxwcragjxxn8x";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/mrcjkb/haskell-tools.nvim/archive/3.0.2.zip";
    sha256 = "1rv1r0laizq866lj06akhy97zr9wdfczp1caql36k2xk4d8sbzx7";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mrcjkb/haskell-tools.nvim";
    description = "Supercharge your Haskell experience in neovim!";
    license.fullName = "GPL-2.0";
  };
}) {};

http = callPackage({ basexx, binaryheap, bit32, buildLuarocksPackage, compat53, cqueues, fetchurl, fetchzip, fifo, lpeg, lpeg_patterns, lua, luaOlder, luaossl }:
buildLuarocksPackage {
  pname = "http";
  version = "0.3-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/http-0.3-0.rockspec";
    sha256 = "0fn3irkf5nnmfc83alc40b316hs8l7zdq2xlaiaa65sjd8acfvia";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/daurnimator/lua-http/archive/v0.3.zip";
    sha256 = "1pqxxxifl2j1cik3kgayx43v6py5jp6r22myhvxfffysb3b84a2l";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ basexx binaryheap bit32 compat53 cqueues fifo lpeg lpeg_patterns lua luaossl ];

  meta = {
    homepage = "https://github.com/daurnimator/lua-http";
    description = "HTTP library for Lua";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT";
  };
}) {};

image-nvim = callPackage(
{ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder, magick }:
buildLuarocksPackage {
  pname = "image.nvim";
  version = "1.2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/image.nvim-1.2.0-1.rockspec";
    sha256 = "0732fk2p2v9f72689jms4pdjsx9m7vdi1ib65jfz7q4lv9pdx508";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/3rd/image.nvim/archive/v1.2.0.zip";
    sha256 = "1v4db60yykjajabmf12zjcg47bb814scjrig0wvn4yc11isinymg";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua magick ];

  meta = {
    homepage = "https://github.com/3rd/image.nvim";
    description = "🖼️ Bringing images to Neovim.";
    license.fullName = "MIT";
  };
}) {};

inspect = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "inspect";
  version = "3.1.3-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/inspect-3.1.3-0.rockspec";
    sha256 = "1iivb2jmz0pacmac2msyqwvjjx8q6py4h959m8fkigia6srg5ins";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/kikito/inspect.lua/archive/v3.1.3.tar.gz";
    sha256 = "1sqylz5hmj5sbv4gi9988j6av3cb5lwkd7wiyim1h5lr7xhnlf23";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/kikito/inspect.lua";
    description = "Lua table visualizer, ideal for debugging";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

jsregexp = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "jsregexp";
  version = "0.0.6-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/jsregexp-0.0.6-1.rockspec";
    sha256 = "1m3vqv1p44akk020c3l3n8pdxs30rl5509gbs3rr13hmqlvil4cs";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/kmarius/jsregexp.git",
  "rev": "b5a81e21d0875667ba2458ac8ae903afd5568698",
  "date": "2023-02-12T14:19:03+01:00",
  "path": "/nix/store/aj42wy1yp53w406id33dyxpv1ws23g4b-jsregexp",
  "sha256": "0l7hn5f2jl4n2bpikb72szfzgc192jy3ig5pxx9061j44amyq89m",
  "hash": "sha256-NSHsqyJEBgNS77e8OLwUKbD33dfirBnvEpZQKVyx8FA=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/kmarius/jsregexp";
    description = "javascript (ECMA19) regular expressions for lua";
    license.fullName = "MIT";
  };
}) {};

ldbus = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "ldbus";
  version = "scm-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/ldbus-scm-0.rockspec";
    sha256 = "1c0h6fx7avzh89hl17v6simy1p4mjg8bimlsbjybks0zxznd8rbm";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/daurnimator/ldbus.git",
  "rev": "6d4909c983c8a0e2c7384bac8055c628aa524ea2",
  "date": "2021-11-10T23:58:54+11:00",
  "path": "/nix/store/j830jk2hkanz7abkdsbvg2warsyr0a2c-ldbus",
  "sha256": "18q98b98mfvjzbyssf18bpnlx4hsx4s9lwcwia4z9dxiaiw7b77j",
  "hash": "sha256-8px1eFSxt/SJipxxmjTpGpJO7V0oOK39+nK7itJCCaM=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/daurnimator/ldbus";
    description = "A Lua library to access dbus.";
    license.fullName = "MIT/X11";
  };
}) {};

ldoc = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, markdown, penlight }:
buildLuarocksPackage {
  pname = "ldoc";
  version = "1.5.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/ldoc-1.5.0-1.rockspec";
    sha256 = "1c0yx9j3yqlzxpmspz7n7l1nvh2sww84zhkb1fsbg042sr8h9bxp";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/ldoc.git",
  "rev": "09f82c959c50d8c3d5a968c379b1c75de66b002d",
  "date": "2023-05-03T00:05:39+03:00",
  "path": "/nix/store/7l5xpw1grnwr5m8myll63gyy4311glb1-ldoc",
  "sha256": "0g65dd51l42693jr3251p6s40950wcwfr1kspjvc2frkwm7qpv9i",
  "hash": "sha256-Me2LT+UzO8G2vHqG7DjjoCRAtLmhiJHlSEYQGkprxTw=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  propagatedBuildInputs = [ markdown penlight ];

  meta = {
    homepage = "http://lunarmodules.github.io/ldoc";
    description = "A Lua Documentation Tool";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

lgi = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lgi";
  version = "0.9.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lgi-0.9.2-1.rockspec";
    sha256 = "1gqi07m4bs7xibsy4vx8qgyp3yb1wnh0gdq1cpwqzv35y6hn5ds3";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/pavouk/lgi.git",
  "rev": "0fdcf8c677094d0c109dfb199031fdbc0c9c47ea",
  "date": "2017-10-09T20:55:55+02:00",
  "path": "/nix/store/vh82n8pc8dy5c8nph0vssk99vv7q4qg2-lgi",
  "sha256": "03rbydnj411xpjvwsyvhwy4plm96481d7jax544mvk7apd8sd5jj",
  "hash": "sha256-UpamUbvqzF0JKV3J0wIiJlV6iedwe823vD0EIm3zKw8=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/pavouk/lgi";
    description = "Lua bindings to GObject libraries";
    license.fullName = "MIT/X11";
  };
}) {};

linenoise = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "linenoise";
  version = "0.9-1";

  src = fetchurl {
    url    = "https://github.com/hoelzro/lua-linenoise/archive/0.9.tar.gz";
    sha256 = "177h6gbq89arwiwxah9943i8hl5gvd9wivnd1nhmdl7d8x0dn76c";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/hoelzro/lua-linenoise";
    description = "A binding for the linenoise command line library";
    license.fullName = "MIT/X11";
  };
}) {};

ljsyscall = callPackage({ buildLuarocksPackage, fetchurl, lua }:
buildLuarocksPackage {
  pname = "ljsyscall";
  version = "0.12-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/ljsyscall-0.12-1.rockspec";
    sha256 = "0zna5s852vn7q414z56kkyqwpighaghyq7h7in3myap4d9vcgm01";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/justincormack/ljsyscall/archive/v0.12.tar.gz";
    sha256 = "1w9g36nhxv92cypjia7igg1xpfrn3dbs3hfy6gnnz5mx14v50abf";
  };

  disabled = (lua.luaversion != "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.myriabit.com/ljsyscall/";
    description = "LuaJIT Linux syscall FFI";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT";
  };
}) {};

lmathx = callPackage({ buildLuarocksPackage, fetchurl, lua }:
buildLuarocksPackage {
  pname = "lmathx";
  version = "20150624-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lmathx-20150624-1.rockspec";
    sha256 = "181wzsj1mxjyia43y8zwaydxahnl7a70qzcgc8jhhgic7jyi9pgv";
  }).outPath;
  src = fetchurl {
    url    = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.3/lmathx.tar.gz";
    sha256 = "1r0ax3lq4xx6469aqc6qlfl3jynlghzhl5j65mpdj0kyzv4nknzf";
  };

  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#lmathx";
    description = "C99 extensions for the math library";
    maintainers = with lib.maintainers; [ alexshpilkin ];
    license.fullName = "Public domain";
  };
}) {};

lmpfrlib = callPackage({ buildLuarocksPackage, fetchurl, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "lmpfrlib";
  version = "20170112-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lmpfrlib-20170112-2.rockspec";
    sha256 = "1x7qiwmk5b9fi87fn7yvivdsis8h9fk9r3ipqiry5ahx72vzdm7d";
  }).outPath;
  src = fetchurl {
    url    = "http://www.circuitwizard.de/lmpfrlib/lmpfrlib.c";
    sha256 = "1bkfwdacj1drzqsfxf352fjppqqwi5d4j084jr9vj9dvjb31rbc1";
  };

  disabled = (luaOlder "5.3") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.circuitwizard.de/lmpfrlib/lmpfrlib.html";
    description = "Lua API for the GNU MPFR library";
    maintainers = with lib.maintainers; [ alexshpilkin ];
    license.fullName = "LGPL";
  };
}) {};

loadkit = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "loadkit";
  version = "1.1.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/loadkit-1.1.0-1.rockspec";
    sha256 = "08fx0xh90r2zvjlfjkyrnw2p95xk1a0qgvlnq4siwdb2mm6fq12l";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/leafo/loadkit.git",
  "rev": "95b13a36442f59b41ab52df96d52233c4a725dfd",
  "date": "2023-08-17T11:36:25-07:00",
  "path": "/nix/store/9xcy2p5pxiq0p17szv8p2lagb6xzb8c8-loadkit",
  "sha256": "0hivmn5r1scxv3nckm4hqfplq33wiab3ypjwsfdkmp3bdri0dhxs",
  "hash": "sha256-usMGYm5r3Dqb01xeP5aKfAxMr8OQ1Mns2J3pkIutO0I=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/leafo/loadkit";
    description = "Loadkit allows you to load arbitrary files within the Lua package path";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT";
  };
}) {};

lpeg = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lpeg";
  version = "1.1.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lpeg-1.1.0-1.rockspec";
    sha256 = "03af1p00madfhfxjzrsxb0jm0n49ixwadnkdp0vbgs77d2v985jn";
  }).outPath;
  src = fetchurl {
    url    = "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.1.0.tar.gz";
    sha256 = "0aimsjpcpkh3kk65f0pg1z2bp6d83rn4dg6pgbx1yv14s9kms5ab";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.inf.puc-rio.br/~roberto/lpeg.html";
    description = "Parsing Expression Grammars For Lua";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

lpeg_patterns = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lpeg, lua }:
buildLuarocksPackage {
  pname = "lpeg_patterns";
  version = "0.5-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lpeg_patterns-0.5-0.rockspec";
    sha256 = "1vzl3ryryc624mchclzsfl3hsrprb9q214zbi1xsjcc4ckq5qfh7";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/daurnimator/lpeg_patterns/archive/v0.5.zip";
    sha256 = "1s3c179a64r45ffkawv9dnxw4mzwkzj00nr9z2gs5haajgpjivw6";
  };

  propagatedBuildInputs = [ lpeg lua ];

  meta = {
    homepage = "https://github.com/daurnimator/lpeg_patterns/archive/v0.5.zip";
    description = "a collection of LPEG patterns";
    license.fullName = "MIT";
  };
}) {};

lpeglabel = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lpeglabel";
  version = "1.6.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lpeglabel-1.6.0-1.rockspec";
    sha256 = "13gc32pggng6f95xx5zw9n9ian518wlgb26mna9kh4q2xa1k42pm";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/sqmedeiros/lpeglabel/archive/v1.6.0-1.tar.gz";
    sha256 = "1i02lsxj20iygqm8fy6dih1gh21lqk5qj1mv14wlrkaywnv35wcv";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/sqmedeiros/lpeglabel/";
    description = "Parsing Expression Grammars For Lua with Labeled Failures";
    license.fullName = "MIT/X11";
  };
}) {};

lrexlib-gnu = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lrexlib-gnu";
  version = "2.9.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lrexlib-gnu-2.9.2-1.rockspec";
    sha256 = "14dp5lzpz2prvimpcbqjygbyh9h791h0ywjknj9wgrjjd62qsy6i";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/rrthomas/lrexlib.git",
  "rev": "9aa5e7e9ca47da1bd0e023dfa0b1b2d43aa358f3",
  "date": "2023-11-05T17:32:50+00:00",
  "path": "/nix/store/z74bw029468iizgrv19wllpzsvazj3bg-lrexlib",
  "sha256": "15y9ha28qq08b100a32s72h6rx1bqs7gl5h7j3zacy5ixyyl6cqg",
  "hash": "sha256-DzNDve+xeKb+kAcW+o7GK/RsoDhaDAVAWAhgjISCyZc=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (GNU flavour).";
    license.fullName = "MIT/X11";
  };
}) {};

lrexlib-pcre = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lrexlib-pcre";
  version = "2.9.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lrexlib-pcre-2.9.2-1.rockspec";
    sha256 = "1214ssm6apgprryqvijjjn82ikb27ylq94yijqf7qjyiy6pz7dc1";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/rrthomas/lrexlib.git",
  "rev": "9aa5e7e9ca47da1bd0e023dfa0b1b2d43aa358f3",
  "date": "2023-11-05T17:32:50+00:00",
  "path": "/nix/store/z74bw029468iizgrv19wllpzsvazj3bg-lrexlib",
  "sha256": "15y9ha28qq08b100a32s72h6rx1bqs7gl5h7j3zacy5ixyyl6cqg",
  "hash": "sha256-DzNDve+xeKb+kAcW+o7GK/RsoDhaDAVAWAhgjISCyZc=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (PCRE flavour).";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

lrexlib-posix = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lrexlib-posix";
  version = "2.9.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lrexlib-posix-2.9.2-1.rockspec";
    sha256 = "1i11cdvz09a3wjhfjgc88g0mdmdrk13fnhhgskzgm5cmhsdx4s0i";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/rrthomas/lrexlib.git",
  "rev": "9aa5e7e9ca47da1bd0e023dfa0b1b2d43aa358f3",
  "date": "2023-11-05T17:32:50+00:00",
  "path": "/nix/store/z74bw029468iizgrv19wllpzsvazj3bg-lrexlib",
  "sha256": "15y9ha28qq08b100a32s72h6rx1bqs7gl5h7j3zacy5ixyyl6cqg",
  "hash": "sha256-DzNDve+xeKb+kAcW+o7GK/RsoDhaDAVAWAhgjISCyZc=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (POSIX flavour).";
    license.fullName = "MIT/X11";
  };
}) {};

lua-cjson = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua-cjson";
  version = "2.1.0.10-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-cjson-2.1.0.10-1.rockspec";
    sha256 = "05sp7rq72x4kdkyid1ch0yyscwsi5wk85d2hj6xwssz3h8n8drdg";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/openresty/lua-cjson",
  "rev": "96e6e0ce67ed070a52223c1e9518c9018b1ce376",
  "date": "2021-12-10T20:19:58+08:00",
  "path": "/nix/store/1ac8lz6smfa8zqfipqfsg749l9rw4ly9-lua-cjson",
  "sha256": "03hdsv7d77mggis58k8fmlpbh1d544m0lfqyl9rpjcqkiqs1qvza",
  "hash": "sha256-6m8cNI4TM3lzoh47CiohpQW4Lq0OTVR0fK+e087WDQ4=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.kyne.com.au/~mark/software/lua-cjson.php";
    description = "A fast JSON encoding/parsing module";
    license.fullName = "MIT";
  };
}) {};

lua-cmsgpack = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua-cmsgpack";
  version = "0.4.0-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-cmsgpack-0.4.0-0.rockspec";
    sha256 = "10cvr6knx3qvjcw1q9v05f2qy607mai7lbq321nx682aa0n1fzin";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/antirez/lua-cmsgpack.git",
  "rev": "dec1810a70d2948725f2e32cc38163de62b9d9a7",
  "date": "2015-06-03T08:39:04+02:00",
  "path": "/nix/store/ksqvl7hbd5s7nb6hjffyic1shldac4z2-lua-cmsgpack",
  "sha256": "0j0ahc9rprgl6dqxybaxggjam2r5i2wqqsd6764n0d7fdpj9fqm0",
  "hash": "sha256-oGKX5G3uNGCJOaZpjLmIJYuq5HtdLd9xM/TlmxODCkg=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/antirez/lua-cmsgpack";
    description = "MessagePack C implementation and bindings for Lua 5.1/5.2/5.3";
    license.fullName = "Two-clause BSD";
  };
}) {};

lua-curl = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "lua-curl";
  version = "0.3.13-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-curl-0.3.13-1.rockspec";
    sha256 = "0lz534sm35hxazf1w71hagiyfplhsvzr94i6qyv5chjfabrgbhjn";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/Lua-cURL/Lua-cURLv3/archive/v0.3.13.zip";
    sha256 = "0gn59bwrnb2mvl8i0ycr6m3jmlgx86xlr9mwnc85zfhj7zhi5anp";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/Lua-cURL";
    description = "Lua binding to libcurl";
    license.fullName = "MIT/X11";
  };
}) {};

lua-ffi-zlib = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua-ffi-zlib";
  version = "0.6-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-ffi-zlib-0.6-0.rockspec";
    sha256 = "060sac715f1ris13fjv6gwqm0lk6by0a2zhldxd8hdrc0jss8p34";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/hamishforbes/lua-ffi-zlib",
  "rev": "61e95cb434e4047c8bc65a180c293a05bf754416",
  "date": "2023-08-11T09:28:16+12:00",
  "path": "/nix/store/gfyr81q84mgpgwyh28xpzlf34ndjkfwc-lua-ffi-zlib",
  "sha256": "0r6vima495h0d4f8ibf3fv9b6k7rqnavgvsy78dybslrm7lwsz4p",
  "hash": "sha256-l3zN6amZ6uUbOl7vt5XF+Uyz0nbDrYgcaQCWRFSN22Q=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/hamishforbes/lua-ffi-zlib";
    description = "A Lua module using LuaJIT's FFI feature to access zlib.";
  };
}) {};

lua-iconv = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua-iconv";
  version = "7.0.0-4";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-iconv-7.0.0-4.rockspec";
    sha256 = "0j34zf98wdr6ks6snsrqi00vwm3ngsa5f74kadsn178iw7hd8c3q";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/lunarmodules/lua-iconv/archive/v7.0.0/lua-iconv-7.0.0.tar.gz";
    sha256 = "0arp0h342hpp4kfdxc69yxspziky4v7c13jbf12yrs8f1lnjzr0x";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/lunarmodules/lua-iconv/";
    description = "Lua binding to the iconv";
    license.fullName = "MIT/X11";
  };
}) {};

lua-lsp = callPackage({ buildLuarocksPackage, dkjson, fetchgit, fetchurl, inspect, lpeglabel, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "lua-lsp";
  version = "0.1.0-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-lsp-0.1.0-2.rockspec";
    sha256 = "19jsz00qlgbyims6cg8i40la7v8kr7zsxrrr3dg0kdg0i36xqs6c";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/Alloyed/lua-lsp",
  "rev": "6afbe53b43d9fb2e70edad50081cc3062ca3d78f",
  "date": "2020-10-17T15:07:11-04:00",
  "path": "/nix/store/qn9syhm875k1qardhhsp025cm3dbnqvm-lua-lsp",
  "sha256": "17k3jq61jz6j9bz4vc3hmsfx1s26cfgq1acja8fqyixljklmsbqp",
  "hash": "sha256-Fy9d6ZS0R48dUpKpgJ9jRujQna5wsE3+StJ8GQyWY54=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ dkjson inspect lpeglabel lua ];

  meta = {
    homepage = "https://github.com/Alloyed/lua-lsp";
    description = "A Language Server implementation for lua, the language";
    license.fullName = "MIT";
  };
}) {};

lua-messagepack = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua-messagepack";
  version = "0.5.4-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-messagepack-0.5.4-1.rockspec";
    sha256 = "1jygn6f8ab69z0nn1gib45wvjp075gzxp54vdmgxb3qfar0q70kr";
  }).outPath;
  src = fetchurl {
    url    = "https://framagit.org/fperrad/lua-MessagePack/raw/releases/lua-messagepack-0.5.4.tar.gz";
    sha256 = "0kk1n9kf6wip8k2xx4wjlv7647biji2p86v4jf0h6d6wkaypq0kz";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://fperrad.frama.io/lua-MessagePack/";
    description = "a pure Lua implementation of the MessagePack serialization format";
    license.fullName = "MIT/X11";
  };
}) {};

lua-protobuf = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua-protobuf";
  version = "0.5.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-protobuf-0.5.0-1.rockspec";
    sha256 = "08z73rsqi7ysdyjcwfqyr8z6i5r43kx5fd8l32wlzv6cx6yvlqc9";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/starwing/lua-protobuf.git",
  "rev": "a256c34e12cad643d6ad189bddcbc314da9b0658",
  "date": "2023-04-30T02:11:27+08:00",
  "path": "/nix/store/n7ihjh36kp2f80016f9y8xydia2pclzq-lua-protobuf",
  "sha256": "1kbanbgvmzcfnxq30f8hmirgc1d768lacpjihis9961pc7w96l9n",
  "hash": "sha256-NlGT+GE3mJR0hFFepigypwX2cqwQOTBwt479ut+yas0=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/starwing/lua-protobuf";
    description = "protobuf data support for Lua";
    maintainers = with lib.maintainers; [ lockejan ];
    license.fullName = "MIT";
  };
}) {};

lua-resty-http = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua-resty-http";
  version = "0.17.1-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-http-0.17.1-0.rockspec";
    sha256 = "05gid7c5i459clw707z1jic42s52ap4z66dbr9ims5znaq5s3wdk";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/ledgetech/lua-resty-http",
  "rev": "4ab4269cf442ba52507aa2c718f606054452fcad",
  "date": "2023-03-22T09:48:56+00:00",
  "path": "/nix/store/ykd1d5fa56i1c286k58jm233lqvdv2mi-lua-resty-http",
  "sha256": "0xdhygjqjpfkq1bq8b09fichww57q1z694lz16i3hcc3g4sr4hxg",
  "hash": "sha256-r0OSNXmDMTiiCZ+SZH7Ap3AOWXQJLIRXwNNdieXzsHU=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/ledgetech/lua-resty-http";
    description = "Lua HTTP client cosocket driver for OpenResty / ngx_lua.";
    license.fullName = "2-clause BSD";
  };
}) {};

lua-resty-jwt = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, lua-resty-openssl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-resty-jwt";
  version = "0.2.3-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-jwt-0.2.3-0.rockspec";
    sha256 = "1fxdwfr4pna3fdfm85kin97n53caq73h807wjb59wpqiynbqzc8c";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/cdbattags/lua-resty-jwt",
  "rev": "b3d5c085643fa95099e72a609c57095802106ff9",
  "date": "2021-01-20T16:53:57-05:00",
  "path": "/nix/store/z4a8ffxj2i3gbjp0f8r377cdp88lkzl4-lua-resty-jwt",
  "sha256": "07w8r8gqbby06x493qzislig7a3giw0anqr4ivp3g2ms8v9fnng6",
  "hash": "sha256-5lnr0ka6ijfujiRjqwCPb6jzItXx45FIN8CvhR/KiB8=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua-resty-openssl ];

  meta = {
    homepage = "https://github.com/cdbattags/lua-resty-jwt";
    description = "JWT for ngx_lua and LuaJIT.";
    license.fullName = "Apache License Version 2";
  };
}) {};

lua-resty-openidc = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, lua-resty-http, lua-resty-jwt, lua-resty-session, luaOlder }:
buildLuarocksPackage {
  pname = "lua-resty-openidc";
  version = "1.7.6-3";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-openidc-1.7.6-3.rockspec";
    sha256 = "08nq24kxw51xiyyp5jailyqjfsgz4m4fzy4hb7g3fv76vcsf8msp";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/zmartzone/lua-resty-openidc",
  "rev": "5a7b9e2cfe4f5aab7c60032e6ca94d2d534f7d19",
  "date": "2023-01-30T19:06:51+01:00",
  "path": "/nix/store/nyd2jqhlq8gx4chapqyxk2q4dsxgm8hz-lua-resty-openidc",
  "sha256": "15dh9z7y84n840x02xsn2m9h9hdakbbv4p1z7dfz85v5w5i6c86p",
  "hash": "sha256-1yBmYuFlF/RdOz9csteaqsEEUxVWdwE6IMgS5M9PsJU=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua-resty-http lua-resty-jwt lua-resty-session ];

  meta = {
    homepage = "https://github.com/zmartzone/lua-resty-openidc";
    description = "A library for NGINX implementing the OpenID Connect Relying Party (RP) and the OAuth 2.0 Resource Server (RS) functionality";
    license.fullName = "Apache 2.0";
  };
}) {};

lua-resty-openssl = callPackage({ buildLuarocksPackage, fetchgit, fetchurl }:
buildLuarocksPackage {
  pname = "lua-resty-openssl";
  version = "1.0.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-openssl-1.0.2-1.rockspec";
    sha256 = "000ak4rfm56z7g2b7jr7k2m4hp6kcx970cnv29acjazrz6kr60r2";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/fffonion/lua-resty-openssl.git",
  "rev": "5aba923e78ae0f213f3b4719effa879e3971821f",
  "date": "2023-11-22T15:44:01+08:00",
  "path": "/nix/store/fww02frnja73z8bhxqz5nyji5nam77ab-lua-resty-openssl",
  "sha256": "10fxfjafl9wyv2jz7j25xkklx1c2ykvi0yqskyij45d0rzimil5z",
  "hash": "sha256-v9BY48+gFSKjnxp7EPf0goVO5+xFyPOl2J4n6pR03YE=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;


  meta = {
    homepage = "https://github.com/fffonion/lua-resty-openssl";
    description = "No summary";
    license.fullName = "BSD";
  };
}) {};

lua-resty-session = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, lua-ffi-zlib, lua-resty-openssl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-resty-session";
  version = "4.0.5-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-session-4.0.5-1.rockspec";
    sha256 = "0h0kqwna46mrraq310qjb7yigxwv13n4czk24xnqr21czxsskzkg";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/bungle/lua-resty-session.git",
  "rev": "5f2aed616d16fa7ca04dc40e23d6941740cd634d",
  "date": "2023-08-16T18:24:43+03:00",
  "path": "/nix/store/s6i1idv9lx52x7lcl0kc2c9sm9pic4kq-lua-resty-session",
  "sha256": "08pih1baqhlvsqvcr1zzympmn8v7gskmis6ffhigll37hbzvljcz",
  "hash": "sha256-n0m6/4JnUPoidM7oWKd+ZyNbb/X/h8w21ptCrFaA8SI=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua-ffi-zlib lua-resty-openssl ];

  meta = {
    homepage = "https://github.com/bungle/lua-resty-session";
    description = "Session Library for OpenResty - Flexible and Secure";
    license.fullName = "BSD";
  };
}) {};

lua-rtoml = callPackage({ buildLuarocksPackage, fetchgit, lua, luaOlder, luarocks-build-rust-mlua }:
buildLuarocksPackage {
  pname = "lua-rtoml";
  version = "0.2-0";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lblasc/lua-rtoml.git",
  "rev": "c83f56b9519d85968d663308e303f384c55c7b18",
  "date": "2023-11-02T14:28:19+01:00",
  "path": "/nix/store/x6mm838p27gwk45j23jkd0cpzxncxgci-lua-rtoml",
  "sha256": "11i2km1k686nbh2ylfrcn3grd816vdhnigjjaiykkgwj0i8il6ix",
  "hash": "sha256-PRoaUQSSvzl9VFK+aGHbJqCW37AsO+oFXNYgM0OdIoY=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luarocks-build-rust-mlua ];

  meta = {
    homepage = "https://github.com/lblasc/lua-rtoml";
    description = "Lua bindings for the Rust toml crate.";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT";
  };
}) {};

lua-subprocess = callPackage({ buildLuarocksPackage, fetchgit, lua, luaOlder }:
buildLuarocksPackage {
  pname = "subprocess";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/0x0ade/lua-subprocess.git",
  "rev": "bfa8e97da774141f301cfd1106dca53a30a4de54",
  "date": "2021-01-09T22:31:54+01:00",
  "path": "/nix/store/3lr7n1k85kbf718wxr51xd40i8dfs5qd-lua-subprocess",
  "sha256": "0p91hda0b0hpgdbff5drcyygaizq086gw8vnvzn0y0fg3mc9if70",
  "hash": "sha256-4LiYWB3PAQ/s33Yj/gwC+Ef1vGe5FedWexeCBVSDIV0=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/xlq/lua-subprocess";
    description = "A Lua module written in C that allows you to create child processes and communicate with them.";
    maintainers = with lib.maintainers; [ scoder12 ];
    license.fullName = "MIT";
  };
}) {};

lua-term = callPackage({ buildLuarocksPackage, fetchurl }:
buildLuarocksPackage {
  pname = "lua-term";
  version = "0.7-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-term-0.7-1.rockspec";
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

lua-toml = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua-toml";
  version = "2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-toml-2.0-1.rockspec";
    sha256 = "0zd3hrj1ifq89rjby3yn9y96vk20ablljvqdap981navzlbb7zvq";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/jonstoler/lua-toml.git",
  "rev": "13731a5dd48c8c314d2451760604810bd6221085",
  "date": "2017-12-08T16:30:50-08:00",
  "path": "/nix/store/cnpflpyj441c65jhb68hjr2bcvnj9han-lua-toml",
  "sha256": "0lklhgs4n7gbgva5frs39240da1y4nwlx6yxaj3ix6r5lp9sh07b",
  "hash": "sha256-6wCo06Ulmx6HVN2bTrklPqgGiEhDZ1fUfusdS/SDdFI=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/jonstoler/lua-toml";
    description = "toml decoder/encoder for Lua";
    license.fullName = "MIT";
  };
}) {};

lua-yajl = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua-yajl";
  version = "2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-yajl-2.0-1.rockspec";
    sha256 = "0h600zgq5qc9z3cid1kr35q3qb98alg0m3qf0a3mfj33hya6pcxp";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/brimworks/lua-yajl.git",
  "rev": "c0b598a70966b6cabc57a110037faf9091436f30",
  "date": "2020-11-12T06:22:23-08:00",
  "path": "/nix/store/9acgxpqk52kwn03m5xasn4f6mmsby2r9-lua-yajl",
  "sha256": "1frry90y7vqnw1rd1dfnksilynh0n24gfhkmjd6wwba73prrg0pf",
  "hash": "sha256-7oKX8x1HLc5Nk3VC94iwAFpPo57WtdBy4Bbv40HyObs=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/brimworks/lua-yajl";
    description = "Integrate the yajl JSON library with Lua.";
    maintainers = with lib.maintainers; [ pstn ];
    license.fullName = "MIT/X11";
  };
}) {};

lua-zlib = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua-zlib";
  version = "1.2-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-zlib-1.2-2.rockspec";
    sha256 = "1ycjy59w6rkhasqqbiyra0f1sj87fswcz25zwxy4gyv7rrwy5hxd";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/brimworks/lua-zlib.git",
  "rev": "a305d98f473d0a253b6fd740ce60d7d5a5f1cda0",
  "date": "2017-10-07T08:26:37-07:00",
  "path": "/nix/store/6hjfczd3xkilkdxidgqzdrwmaiwnlf05-lua-zlib",
  "sha256": "1cv12s5c5lihmf3hb0rz05qf13yihy1bjpb7448v8mkiss6y1s5c",
  "hash": "sha256-rOjgjdZxVrQRIWdduYKH0Y/gcAE/gwWHqzDSwooWYbM=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/brimworks/lua-zlib";
    description = "Simple streaming interface to zlib for Lua.";
    maintainers = with lib.maintainers; [ koral ];
    license.fullName = "MIT";
  };
}) {};

lua_cliargs = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua_cliargs";
  version = "3.0-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua_cliargs-3.0-2.rockspec";
    sha256 = "0vlmwrldwlxdfkak9kapydfs4ny4pwg3qpkv5agn6lw6gq0aq5za";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/amireh/lua_cliargs/archive/v3.0-2.tar.gz";
    sha256 = "0vhpgmy9a8wlxp8a15pnfqfk0aj7pyyb5m41nnfxynx580a6y7cp";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/amireh/lua_cliargs";
    description = "A command-line argument parser.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

luabitop = callPackage({ buildLuarocksPackage, fetchgit, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luabitop";
  version = "1.0.2-3";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/teto/luabitop.git",
  "rev": "8d7b674386460ca83e9510b3a8a4481344eb90ad",
  "date": "2021-08-30T10:14:03+02:00",
  "path": "/nix/store/sdnza0zpmlkz9jppnysasbvqy29f4zia-luabitop",
  "sha256": "1b57f99lrjbwsi4m23cq5kpj0dbpxh3xwr0mxs2rzykr2ijpgwrw",
  "hash": "sha256-PPN3ZRR5+p+F7hVk3gfsdzUg7yyYDVFJ1HzJTFNyp6w=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.3");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://bitop.luajit.org/";
    description = "Lua Bit Operations Module";
    license.fullName = "MIT/X license";
  };
}) {};

luacheck = callPackage({ argparse, buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder, luafilesystem }:
buildLuarocksPackage {
  pname = "luacheck";
  version = "1.1.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luacheck-1.1.1-1.rockspec";
    sha256 = "11nrryqff2yis5s7jscbyv221p21i9sh924x7g9l3d6ijns8zmba";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/luacheck.git",
  "rev": "ababb6d403d634eb74d2c541035e9ede966e710d",
  "date": "2023-06-10T11:27:25+03:00",
  "path": "/nix/store/wkrhda7nww45g1waxdv9ghm35mwbvlfq-luacheck",
  "sha256": "0abd5rfxv667n8d8v3g9cnkyghiwzhj3yk498gr2agd3mfcni7d7",
  "hash": "sha256-p51omaujPSXyQ4lMPyT8PMLnp2XpjY0asseY3V0ubSk=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ argparse lua luafilesystem ];

  meta = {
    homepage = "https://github.com/lunarmodules/luacheck";
    description = "A static analyzer and a linter for Lua";
    license.fullName = "MIT";
  };
}) {};

luacov = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luacov";
  version = "0.15.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luacov-0.15.0-1.rockspec";
    sha256 = "18byfl23c73pazi60hsx0vd74hqq80mzixab76j36cyn8k4ni9db";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/luacov.git",
  "rev": "19b52ca0298c8942df82dd441d7a4a588db4c413",
  "date": "2021-02-15T18:47:58-03:00",
  "path": "/nix/store/9vm38il9knzx2m66m250qj1fzdfzqg0y-luacov",
  "sha256": "08550nna6qcb5jn6ds1hjm6010y8973wx4qbf9vrvrcn1k2yr6ki",
  "hash": "sha256-cZrsxQyW5Z13cguTzsdJyIMATJUw6GasLItho6wFpSA=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://keplerproject.github.io/luacov/";
    description = "Coverage analysis tool for Lua scripts";
    license.fullName = "MIT";
  };
}) {};

luadbi = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luadbi";
  version = "0.7.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luadbi-0.7.2-1.rockspec";
    sha256 = "0lj1qki20w6bl76cvlcazlmwh170b9wkv5nwlxbrr3cn6w7h370b";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mwild1/luadbi",
  "rev": "73a234c4689e4f87b7520276b6159cc7f6cfd6e0",
  "date": "2019-01-14T09:39:17+00:00",
  "path": "/nix/store/a3qgawila4r4jc2lpdc4mwyzd1gvzazd-luadbi",
  "sha256": "167ivwmczhp98bxzpz3wdxcfj6vi0a10gpi7rdfjs2rbfwkzqvjh",
  "hash": "sha256-UG78J3crCy1dyyfeB4ICcRvpWG98/Pv7QunCzyrf8Zg=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-mysql = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaAtLeast, luaOlder, luadbi }:
buildLuarocksPackage {
  pname = "luadbi-mysql";
  version = "0.7.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luadbi-mysql-0.7.2-1.rockspec";
    sha256 = "0gnyqnvcfif06rzzrdw6w6hchp4jrjiwm0rmfx2r8ljchj2bvml5";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mwild1/luadbi",
  "rev": "73a234c4689e4f87b7520276b6159cc7f6cfd6e0",
  "date": "2019-01-14T09:39:17+00:00",
  "path": "/nix/store/a3qgawila4r4jc2lpdc4mwyzd1gvzazd-luadbi",
  "sha256": "167ivwmczhp98bxzpz3wdxcfj6vi0a10gpi7rdfjs2rbfwkzqvjh",
  "hash": "sha256-UG78J3crCy1dyyfeB4ICcRvpWG98/Pv7QunCzyrf8Zg=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-postgresql = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaAtLeast, luaOlder, luadbi }:
buildLuarocksPackage {
  pname = "luadbi-postgresql";
  version = "0.7.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luadbi-postgresql-0.7.2-1.rockspec";
    sha256 = "07rx4agw4hjyzf8157apdwfqh9s26nqndmkr3wm7v09ygjvdjiix";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mwild1/luadbi",
  "rev": "73a234c4689e4f87b7520276b6159cc7f6cfd6e0",
  "date": "2019-01-14T09:39:17+00:00",
  "path": "/nix/store/a3qgawila4r4jc2lpdc4mwyzd1gvzazd-luadbi",
  "sha256": "167ivwmczhp98bxzpz3wdxcfj6vi0a10gpi7rdfjs2rbfwkzqvjh",
  "hash": "sha256-UG78J3crCy1dyyfeB4ICcRvpWG98/Pv7QunCzyrf8Zg=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-sqlite3 = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaAtLeast, luaOlder, luadbi }:
buildLuarocksPackage {
  pname = "luadbi-sqlite3";
  version = "0.7.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luadbi-sqlite3-0.7.2-1.rockspec";
    sha256 = "022iba0jbiafz8iv1h0iv95rhcivbfq5yg341nxk3dm87yf220vh";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mwild1/luadbi",
  "rev": "73a234c4689e4f87b7520276b6159cc7f6cfd6e0",
  "date": "2019-01-14T09:39:17+00:00",
  "path": "/nix/store/a3qgawila4r4jc2lpdc4mwyzd1gvzazd-luadbi",
  "sha256": "167ivwmczhp98bxzpz3wdxcfj6vi0a10gpi7rdfjs2rbfwkzqvjh",
  "hash": "sha256-UG78J3crCy1dyyfeB4ICcRvpWG98/Pv7QunCzyrf8Zg=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luaepnf = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lpeg, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luaepnf";
  version = "0.3-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaepnf-0.3-2.rockspec";
    sha256 = "0kqmnj11wmfpc9mz04zzq8ab4mnbkrhcgc525wrq6pgl3p5li8aa";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/siffiejoe/lua-luaepnf.git",
  "rev": "4e0a867ff54cf424e1558781f5d2c85d2dc2137c",
  "date": "2015-01-15T16:54:10+01:00",
  "path": "/nix/store/n7gb0z26sl7dzdyy3bx1y3cz3npsna7d-lua-luaepnf",
  "sha256": "1lvsi3fklhvz671jgg0iqn0xbkzn9qjcbf2ks41xxjz3lapjr6c9",
  "hash": "sha256-iZksr6Ljy94D0VO4xSRO9s/VgcURvCfDMX9DOt2IetM=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lpeg lua ];

  meta = {
    homepage = "http://siffiejoe.github.io/lua-luaepnf/";
    description = "Extended PEG Notation Format (easy grammars for LPeg)";
    license.fullName = "MIT";
  };
}) {};

luaevent = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "luaevent";
  version = "0.4.6-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaevent-0.4.6-1.rockspec";
    sha256 = "03zixadhx4a7nh67n0sm6sy97c8i9va1a78hibhrl7cfbqc2zc7f";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/harningt/luaevent/archive/v0.4.6.tar.gz";
    sha256 = "0pbh315d3p7hxgzmbhphkcldxv2dadbka96131b8j5914nxvl4nx";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/harningt/luaevent";
    description = "libevent binding for Lua";
    license.fullName = "MIT";
  };
}) {};

luaexpat = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "luaexpat";
  version = "1.4.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaexpat-1.4.1-1.rockspec";
    sha256 = "1abwd385x7wnza7qqz5s4aj6m2l1c23pjmbgnpq73q0s17pn1h0c";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/luaexpat.git",
  "rev": "57f8966088abf8a00f8ab0bf88e1b6deea89c0bb",
  "date": "2022-10-04T16:36:23+02:00",
  "path": "/nix/store/dgrdkalikpqdap642qhppha1ajdnsvx0-luaexpat",
  "sha256": "1b4ck23p01ks3hgayan9n33f2kb6jvv63v4ww2mqczc09rqi0q46",
  "hash": "sha256-hmAQcU6AfYar4JzsYfaWZk3hxrDJKq8eHHoGcIeYjKw=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://lunarmodules.github.io/luaexpat";
    description = "XML Expat parsing";
    maintainers = with lib.maintainers; [ arobyn flosse ];
    license.fullName = "MIT/X11";
  };
}) {};

luaffi = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
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
  "hash": "sha256-wRjAtEEy8KSlIoi/IIutL73Vbm1r+zKs26dEP7gzR1o=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/facebook/luaffifb";
    description = "FFI library for calling C functions from lua";
    license.fullName = "BSD";
  };
}) {};

luafilesystem = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "luafilesystem";
  version = "1.8.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luafilesystem-1.8.0-1.rockspec";
    sha256 = "18nkaks0b75dmycljg5vljap5w8d0ysdkg96yl5szgzr7nzrymfa";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/luafilesystem",
  "rev": "7c6e1b013caec0602ca4796df3b1d7253a2dd258",
  "date": "2020-04-22T22:16:42-03:00",
  "path": "/nix/store/qzjav1cmn4zwclpfs0xzykpbv835d84z-luafilesystem",
  "sha256": "16hpwhj6zgkjns3zilcg3lxfijm3cl71v39y9n5lbjk4b9kkwh54",
  "hash": "sha256-pEA+Z1pkykWLTT6NHQ5lo8roOh2P0fiHtnK+byTkF5o=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/keplerproject/luafilesystem";
    description = "File System Library for the Lua Programming Language";
    maintainers = with lib.maintainers; [ flosse ];
    license.fullName = "MIT/X11";
  };
}) {};

lualdap = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lualdap";
  version = "1.4.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lualdap-1.4.0-1.rockspec";
    sha256 = "0n924gxm6ccr9hjk4bi5z70vgh7g75dl7293pab41a2qcrlsj9nk";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lualdap/lualdap",
  "rev": "7a73c883012f9d12a05563afbb3481a57055368c",
  "date": "2023-11-04T09:38:06+01:00",
  "path": "/nix/store/7j6wl1f9qg4kh9zwm8fnc0ky7zhf7qbf-lualdap",
  "sha256": "0xq0xi3ymg5lk6dh7782ddjnz5bjycd2xnc5dp1cwssi37nm7pdv",
  "hash": "sha256-u91T7RlRa87CbYXZLhrzcpVvZWsCnQObmbS86kfsAHc=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://lualdap.github.io/lualdap/";
    description = "A Lua interface to the OpenLDAP library";
    maintainers = with lib.maintainers; [ aanderse ];
    license.fullName = "MIT";
  };
}) {};

lualogging = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, luasocket }:
buildLuarocksPackage {
  pname = "lualogging";
  version = "1.8.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lualogging-1.8.2-1.rockspec";
    sha256 = "164c4xgwkv2ya8fbb22wm48ywc4gx939b574r6bgl8zqayffdqmx";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/lualogging.git",
  "rev": "465c994788f1bc18fca950934fa5ec9a909f496c",
  "date": "2023-01-27T20:29:41+01:00",
  "path": "/nix/store/pvb3yq11xgqhq6559sjd8rkf1x991rrz-lualogging",
  "sha256": "1mz5iiv9pfikkm4ay7j0q6mk3bmcxylnlg9piwda47xxc1zyb1j4",
  "hash": "sha256-RIblf2C9H6Iajzc9aqnvrK4xq8FAHq9InTO6m3aM5dc=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  propagatedBuildInputs = [ luasocket ];

  meta = {
    homepage = "https://github.com/lunarmodules/lualogging";
    description = "A simple API to use logging features";
    license.fullName = "MIT/X11";
  };
}) {};

luaossl = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua }:
buildLuarocksPackage {
  pname = "luaossl";
  version = "20220711-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaossl-20220711-0.rockspec";
    sha256 = "0b68kvfz587ilmb5c1p7920kysg9q4m4fl4cz4d93jl3270mzh8y";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/wahern/luaossl/archive/rel-20220711.zip";
    sha256 = "1a9pgmc6fbhgh1m9ksz9fq057yzz46npqgakcsy9vngg47xacfdb";
  };

  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://25thandclement.com/~william/projects/luaossl.html";
    description = "Most comprehensive OpenSSL module in the Lua universe.";
    license.fullName = "MIT/X11";
  };
}) {};

luaposix = callPackage({ bit32, buildLuarocksPackage, fetchurl, fetchzip, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luaposix";
  version = "34.1.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaposix-34.1.1-1.rockspec";
    sha256 = "0hx6my54axjcb3bklr991wji374qq6mwa3ily6dvb72vi2534nwz";
  }).outPath;
  src = fetchzip {
    url    = "http://github.com/luaposix/luaposix/archive/v34.1.1.zip";
    sha256 = "0863r8c69yx92lalj174qdhavqmcs2cdimjim6k55qj9yn78v9zl";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ bit32 lua ];

  meta = {
    homepage = "http://github.com/luaposix/luaposix/";
    description = "Lua bindings for POSIX";
    maintainers = with lib.maintainers; [ vyp lblasc ];
    license.fullName = "MIT/X11";
  };
}) {};

luarepl = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "luarepl";
  version = "0.10-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luarepl-0.10-1.rockspec";
    sha256 = "12zdljfs4wg55mj7a38iwg7p5i1pmc934v9qlpi61sw4brp6x8d3";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/hoelzro/lua-repl/archive/0.10.tar.gz";
    sha256 = "0wv37h9w6y5pgr39m7yxbf8imkwvaila6rnwjcp0xsxl5c1rzfjm";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/hoelzro/lua-repl";
    description = "A reusable REPL component for Lua, written in Lua";
    license.fullName = "MIT/X11";
  };
}) {};

luarocks-build-rust-mlua = callPackage({ buildLuarocksPackage, fetchgit, fetchurl }:
buildLuarocksPackage {
  pname = "luarocks-build-rust-mlua";
  version = "0.1.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luarocks-build-rust-mlua-0.1.2-1.rockspec";
    sha256 = "1sx908fm2ihpxz2mm54xzkfmdzlqdvrqjkh1zz7rcjgmqba4mh1j";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/khvzak/luarocks-build-rust-mlua",
  "rev": "c8080aa0832563b7f8b2cb85a195c1598ce312e0",
  "date": "2023-06-29T16:47:41+01:00",
  "path": "/nix/store/n7id28r1m11xd550hayv99xhz96vpdjq-luarocks-build-rust-mlua",
  "sha256": "1zh1p5k7xpczi5db3k0fw0ljw9w0xxk1qjjcfg5rcznqjf48i3x7",
  "hash": "sha256-p4+IiJPYfpbLc0xKHGbvgCcuKeAOzLFaiZ/dfma5Af4=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;


  meta = {
    homepage = "https://github.com/khvzak/luarocks-build-rust-mlua";
    description = "A LuaRocks build backend for Lua modules written in Rust using mlua";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

luasec = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder, luasocket }:
buildLuarocksPackage {
  pname = "luasec";
  version = "1.3.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasec-1.3.2-1.rockspec";
    sha256 = "09nqs60cmbq1bi70cdh7v5xjnlsm2mrxv9pmbbvczijvz184jh33";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/brunoos/luasec",
  "rev": "4c06287052d68fdbe7429b8f967cdc8ee94aa44a",
  "date": "2023-08-31T17:09:53-03:00",
  "path": "/nix/store/wnl78b5l3dxw52slphmi4rmr1cd8bd3r-luasec",
  "sha256": "0rrdfbnkd8pgqwh3f0iyd5cxy7g1h0568a88m3sq1z7715js4yx3",
  "hash": "sha256-o3uiZQnn/ID1qAgpZAqA4R3fWWk+Ajcgx++iNu1yLWc=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luasocket ];

  meta = {
    homepage = "https://github.com/brunoos/luasec/wiki";
    description = "A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket.";
    maintainers = with lib.maintainers; [ flosse ];
    license.fullName = "MIT";
  };
}) {};

luasnip = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, jsregexp, lua, luaOlder }:
buildLuarocksPackage {
  pname = "luasnip";
  version = "2.1.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasnip-2.1.1-1.rockspec";
    sha256 = "1jrdai8qsanr6x2vqp70hipsxrxh0abvwr2xwh9p4wr29k4wyycb";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/L3MON4D3/LuaSnip/archive/v2.1.1.zip";
    sha256 = "0mbpwf3sxfrmrza13d9w0hlcmzlrj551g332syp1qhs94abfnnrd";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ jsregexp lua ];

  meta = {
    homepage = "https://github.com/L3MON4D3/LuaSnip";
    description = "Snippet Engine for Neovim written in Lua.";
    license.fullName = "Apache-2.0";
  };
}) {};

luasocket = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "luasocket";
  version = "3.1.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasocket-3.1.0-1.rockspec";
    sha256 = "0wg9735cyz2gj7r9za8yi83w765g0f4pahnny7h0pdpx58pgfx4r";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/luasocket.git",
  "rev": "95b7efa9da506ef968c1347edf3fc56370f0deed",
  "date": "2022-07-27T10:07:00+03:00",
  "path": "/nix/store/r5pqxqjkdwl80nmjkv400mbls7cfymjc-luasocket",
  "sha256": "13hyf9cvny0kxwyg08929kkl31w74j66fj6zg1myyjr9nh5b795h",
  "hash": "sha256-sKSzCrQpS+9reN9IZ4wkh4dB50wiIfA87xN4u1lyHo4=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/lunarmodules/luasocket";
    description = "Network support for the Lua language";
    license.fullName = "MIT";
  };
}) {};

luasql-sqlite3 = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "luasql-sqlite3";
  version = "2.6.0-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasql-sqlite3-2.6.0-2.rockspec";
    sha256 = "1xpbcpl4qhnzpyyszhdsrxhx2qc1dmndh926lv91xwphw7inwdwg";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/luasql.git",
  "rev": "25bf4ffce9323d28cb6f382f7ec9e8951e3084f9",
  "date": "2023-07-19T14:20:27-03:00",
  "path": "/nix/store/949886jxp7sx3yx910lc6d1yf3ym9mx5-luasql",
  "sha256": "00q73j2nzqsm0vmxjkv83qh1dncmr5dgmkrkyxnb5ggygvcbh7w5",
  "hash": "sha256-hR+42H7+vbJs9zPP+lrJldkWIB5oT9nrBlXjb4UcBwM=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.keplerproject.org/luasql/";
    description = "Database connectivity for Lua (SQLite3 driver)";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

luassert = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder, say }:
buildLuarocksPackage {
  pname = "luassert";
  version = "1.9.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luassert-1.9.0-1.rockspec";
    sha256 = "1bkzr03190p33lprgy51nl84aq082fyc3f7s3wkk7zlay4byycxd";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/luassert.git",
  "rev": "8d8dc8a54cc468048a128a867f6449a6c3fdd11a",
  "date": "2022-08-24T00:00:45+03:00",
  "path": "/nix/store/vfcl25wxps5kvh5prjkkjlj1ga3kgw63-luassert",
  "sha256": "0wlp6qdm9dkwzs8lvnj7zvmid4y12v717ywlhxn2brkbjpvl2dwf",
  "hash": "sha256-jjdB95Vr5iVsh5T7E84WwZMW6/5H2k2R/ny2VBs2l3I=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua say ];

  meta = {
    homepage = "https://lunarmodules.github.io/busted/";
    description = "Lua assertions extension";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

luasystem = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "luasystem";
  version = "0.2.1-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasystem-0.2.1-0.rockspec";
    sha256 = "0xj5q7lzsbmlw5d3zbjqf3jpj78wcn348h2jcxn5ph4n4hx73z3n";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/o-lim/luasystem/archive/v0.2.1.tar.gz";
    sha256 = "150bbklchh02gsvpngv56xrrlxxvwpqwrh0yy6z95fnvks7gd0qb";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://olivinelabs.com/luasystem/";
    description = "Platform independent system calls for Lua.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

luaunbound = callPackage({ buildLuarocksPackage, fetchurl, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luaunbound";
  version = "1.0.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaunbound-1.0.0-1.rockspec";
    sha256 = "1zlkibdwrj5p97nhs33cz8xx0323z3kiq5x7v0h3i7v6j0h8ppvn";
  }).outPath;
  src = fetchurl {
    url    = "https://code.zash.se/dl/luaunbound/luaunbound-1.0.0.tar.gz";
    sha256 = "1lsh0ylp5xskygxl5qdv6mhkm1x8xp0vfd5prk5hxkr19jk5mr3d";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://www.zash.se/luaunbound.html";
    description = "A binding to libunbound";
    license.fullName = "MIT";
  };
}) {};

luaunit = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luaunit";
  version = "3.4-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaunit-3.4-1.rockspec";
    sha256 = "111435fa8p2819vcvg76qmknj0wqk01gy9d1nh55c36616xnj54n";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/bluebird75/luaunit/releases/download/LUAUNIT_V3_4/rock-luaunit-3.4.zip";
    sha256 = "0qf07y3229lq3qq1mfkv83gzbc7dgyr67hysqjb5bbk333flv56r";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/bluebird75/luaunit";
    description = "A unit testing framework for Lua";
    maintainers = with lib.maintainers; [ lockejan ];
    license.fullName = "BSD";
  };
}) {};

luautf8 = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "luautf8";
  version = "0.1.5-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luautf8-0.1.5-2.rockspec";
    sha256 = "0v788kk1aj7r70w9fgjlp3qrpjbpa9z9l1m7d13csk0pgfkm5iqz";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/starwing/luautf8/archive/refs/tags/0.1.5.tar.gz";
    sha256 = "077ji840wfmy7hq0y13l01dv6jhasznykf89gk9m672jhz6dxggl";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/starwing/luautf8";
    description = "A UTF-8 support module for Lua";
    maintainers = with lib.maintainers; [ pstn ];
    license.fullName = "MIT";
  };
}) {};

lua-utils-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lua-utils.nvim";
  version = "1.0.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-utils.nvim-1.0.2-1.rockspec";
    sha256 = "0s11j4vd26haz72rb0c5m5h953292rh8r62mvlxbss6i69v2dkr9";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorg/lua-utils.nvim/archive/v1.0.2.zip";
    sha256 = "0bnl2kvxs55l8cjhfpa834bm010n8r4gmsmivjcp548c076msagn";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/nvim-neorg/lua-utils.nvim";
    description = "A set of utility functions for Neovim plugins.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

luazip = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luazip";
  version = "1.2.7-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luazip-1.2.7-1.rockspec";
    sha256 = "1wxy3p2ksaq4s8lg925mi9cvbh875gsapgkzm323dr8qaxxg7mba";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mpeterv/luazip",
  "rev": "e424f667cc5c78dd19bb5eca5a86b3c8698e0ce5",
  "date": "2017-09-05T14:02:52+03:00",
  "path": "/nix/store/idllj442c0iwnx1cpkrifx2afb7vh821-luazip",
  "sha256": "1jlqzqlds3aa3hnp737fm2awcx0hzmwyd87klv0cv13ny5v9f2x4",
  "hash": "sha256-pAuXdvF2hM3ApvOg5nn9EHTGlajujHMtHEoN3Sj+mMo=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mpeterv/luazip";
    description = "Library for reading files inside zip files";
    license.fullName = "MIT";
  };
}) {};

lush-nvim = callPackage({ buildLuarocksPackage, fetchgit, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "lush.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/rktjmp/lush.nvim",
  "rev": "f76741886b356586f9dfe8e312fbd1ab0fd1084f",
  "date": "2023-12-06T09:56:43+11:00",
  "path": "/nix/store/m0zsbahbzqxfzvbgw93qw78g7r4fjhdb-lush.nvim",
  "sha256": "1jvfycqg5s72gmib8038kzyy8fyanl06mkz74rjy878zv8r6nf59",
  "hash": "sha256-qThrMtofHeRlJufPagC1yjvk/Z9oALRifeLo8jDzbss=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/rktjmp/lush.nvim";
    description = "Define Neovim themes as a DSL in lua, with real-time feedback.";
    maintainers = with lib.maintainers; [ teto ];
    license.fullName = "MIT/X11";
  };
}) {};

luuid = callPackage({ buildLuarocksPackage, fetchurl, lua, luaAtLeast, luaOlder}:
buildLuarocksPackage {
  pname = "luuid";
  version = "20120509-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luuid-20120509-2.rockspec";
    sha256 = "1q2fv25wfbiqn49mqv26gs4pyllch311akcf7jjn27l5ik8ji5b6";
  }).outPath;
  src = fetchurl {
    url    = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.2/luuid.tar.gz";
    sha256 = "1bfkj613d05yps3fivmz0j1bxf2zkg9g1yl0ifffgw0vy00hpnvm";
  };

  disabled = (luaOlder "5.2") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#luuid";
    description = "A library for UUID generation";
    license.fullName = "Public domain";
  };
}) {};

luv = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "luv";
  version = "1.44.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luv-1.44.2-1.rockspec";
    sha256 = "07jwi50i16rv7sj914k1q3l9dy9wldbw2skmsdrzlkc57mqvg348";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/luvit/luv/releases/download/1.44.2-1/luv-1.44.2-1.tar.gz";
    sha256 = "0c2wkszxw6gwa4l6g1d2zzh660j13lif6c7a910vq7zn8jycgd9y";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/luvit/luv";
    description = "Bare libuv bindings for lua";
    license.fullName = "Apache 2.0";
  };
}) {};

lyaml = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "lyaml";
  version = "6.2.8-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lyaml-6.2.8-1.rockspec";
    sha256 = "0d0h70kjl5fkq589y1sx8qy8as002dhcf88pf60pghvch002ryi1";
  }).outPath;
  src = fetchzip {
    url    = "http://github.com/gvvaughan/lyaml/archive/v6.2.8.zip";
    sha256 = "0r3jjsd8x2fs1aanki0s1mvpznl16f32c1qfgmicy0icgy5xfch0";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/gvvaughan/lyaml";
    description = "libYAML binding for Lua";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT/X11";
  };
}) {};

magick = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua }:
buildLuarocksPackage {
  pname = "magick";
  version = "1.6.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/magick-1.6.0-1.rockspec";
    sha256 = "1pg150xsxnqvlhxpiy17s9hm4dkc84v46mlwi9rhriynqz8qks9w";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/leafo/magick.git",
  "rev": "6971fa700c4d392130492a3925344b51c7cc54aa",
  "date": "2022-03-10T20:02:11-08:00",
  "path": "/nix/store/fpl99q09zg3qnk4kagxk1djabl1dm47l-magick",
  "sha256": "01b9qsz27f929rz5z7vapqhazxak74sichdwkjwb219nlhrwfncm",
  "hash": "sha256-lVnHM6Q2BbG4nLxBFjU5U/WvIL5qn19+TiK5I77GaQU=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (lua.luaversion != "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/leafo/magick.git";
    description = "Lua bindings to ImageMagick & GraphicsMagick for LuaJIT using FFI";
    maintainers = with lib.maintainers; [ donovanglover ];
    license.fullName = "MIT";
  };
}) {};

markdown = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "markdown";
  version = "0.33-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/markdown-0.33-1.rockspec";
    sha256 = "02sixijfi6av8h59kx3ngrhygjn2sx1c85c0qfy20gxiz72wi1pl";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/mpeterv/markdown",
  "rev": "8c09109924b218aaecbfd4d4b1de538269c4d765",
  "date": "2015-09-27T17:49:28+03:00",
  "path": "/nix/store/akl80hh077hm20bdqj1lksy0fn2285b5-markdown",
  "sha256": "019bk2qprszqncnm8zy6ns6709iq1nwkf7i86nr38f035j4lc11y",
  "hash": "sha256-PgRGiSwDODSyNSgeN7kNOCZwjLbGf1Qts/jrfLGYKwU=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mpeterv/markdown";
    description = "Markdown text-to-html markup system.";
    license.fullName = "MIT/X11";
  };
}) {};

mediator_lua = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "mediator_lua";
  version = "1.1.2-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/mediator_lua-1.1.2-0.rockspec";
    sha256 = "0frzvf7i256260a1s8xh92crwa2m42972qxfq29zl05aw3pyn7bm";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/Olivine-Labs/mediator_lua/archive/v1.1.2-0.tar.gz";
    sha256 = "16zzzhiy3y35v8advmlkzpryzxv5vji7727vwkly86q8sagqbxgs";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://olivinelabs.com/mediator_lua/";
    description = "Event handling through channels";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

middleclass = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "middleclass";
  version = "4.1.1-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/middleclass-4.1.1-0.rockspec";
    sha256 = "10xzs48lr1dy7cx99581r956gl16px0a9gbdlfar41n19r96mhb1";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/kikito/middleclass/archive/v4.1.1.tar.gz";
    sha256 = "11ahv0b9wgqfnabv57rb7ilsvn2vcvxb1czq6faqrsqylvr5l7nh";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/kikito/middleclass";
    description = "A simple OOP library for Lua";
    license.fullName = "MIT";
  };
}) {};

mimetypes = callPackage({ buildLuarocksPackage, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "mimetypes";
  version = "1.0.0-3";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/mimetypes-1.0.0-3.rockspec";
    sha256 = "02f5x5pkz6fba71mp031arrgmddsyivn5fsa0pj3q3a7nxxpmnq9";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/lunarmodules/lua-mimetypes/archive/v1.0.0/lua-mimetypes-1.0.0.tar.gz";
    sha256 = "1rc5lnzvw4cg8wxn4w4sar2xgf5vaivdd2hgpxxcqfzzcmblg1zk";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github/lunarmodules/lua-mimetypes/";
    description = "A simple library for looking up the MIME types of files.";
    license.fullName = "MIT/X11";
  };
}) {};


moonscript = callPackage({ argparse, buildLuarocksPackage, fetchgit, lpeg, lua, luaOlder, luafilesystem }:
buildLuarocksPackage {
  pname = "moonscript";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/leafo/moonscript.git",
  "rev": "d5341c9093c49d3724072b209cde28b5cb0f47c9",
  "date": "2023-11-06T12:54:51-08:00",
  "path": "/nix/store/djmh6brp03gy8nyzxjfvzkpy440fj05z-moonscript",
  "sha256": "1h65cxh5rhnxx99asdydkc9yf6gnf61m97jvl03g31f65jl22lxi",
  "hash": "sha256-sVMhqCzGhfEGoFueVINx9hnnE5vNN61S6t3CXGBnxcA=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ argparse lpeg lua luafilesystem ];

  meta = {
    homepage = "http://moonscript.org";
    description = "A programmer friendly language that compiles to Lua";
    maintainers = with lib.maintainers; [ arobyn ];
    license.fullName = "MIT";
  };
}) {};

mpack = callPackage({ buildLuarocksPackage, fetchurl }:
buildLuarocksPackage {
  pname = "mpack";
  version = "1.0.11-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/mpack-1.0.11-0.rockspec";
    sha256 = "0alydkccamxldij7ki42imd37630d9qnqg22pndcgkawfclfqzqa";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.11/libmpack-lua-1.0.11.tar.gz";
    sha256 = "15np7603rijavycvrjgjp12y64zs36390lg2hsnr5av790cfrnd2";
  };


  meta = {
    homepage = "https://github.com/libmpack/libmpack-lua";
    description = "Lua binding to libmpack";
    license.fullName = "MIT";
  };
}) {};

neotest = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder, plenary-nvim }:
buildLuarocksPackage {
  pname = "neotest";
  version = "4.2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/neotest-4.2.0-1.rockspec";
    sha256 = "0mkjwag6h7psff6rmsirn945ax38dszag0kwch2az2axk1nl6nj8";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neotest/neotest/archive/a2f1cb4072bb29fcc067605fb712bbd83917513e.zip";
    sha256 = "0f8rn9v26v3a6yq0wngdzrgz5rdwlpmnc74b98l1aqb2ikn6gxvd";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua plenary-nvim ];

  meta = {
    homepage = "https://github.com/nvim-neotest/neotest";
    description = "An extensible framework for interacting with tests within NeoVim.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

nlua = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
buildLuarocksPackage {
  pname = "nlua";
  version = "0.1.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/nlua-0.1.0-1.rockspec";
    sha256 = "14ynhy85m2prawym1ap1kplkbicafbczpggzgdnji00frwqa1zvv";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/mfussenegger/nlua/archive/v0.1.0.zip";
    sha256 = "1x3pbv5ngbk0sjgwfpjsv3x49wzq4x29d9rm0hgyyb2g2mwag3jc";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mfussenegger/nlua";
    description = "Neovim as Lua interpreter";
    license.fullName = "GPL-3.0";
  };
}) {};

nui-nvim = callPackage({ buildLuarocksPackage, fetchgit, fetchurl }:
buildLuarocksPackage {
  pname = "nui.nvim";
  version = "0.2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/nui.nvim-0.2.0-1.rockspec";
    sha256 = "0v2z6lgl6hrzcjlzhis8nrkdkh9kvx8zg3q5svi5gyklg7vmcbc2";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/MunifTanjim/nui.nvim.git",
  "rev": "9e3916e784660f55f47daa6f26053ad044db5d6a",
  "date": "2023-07-20T10:45:09+06:00",
  "path": "/nix/store/8zdhjgipjjhi9b1y40r2yk5np4lp39as-nui.nvim",
  "sha256": "14a73dwl56kah9h36b40ir6iylvfs261ysz17qvi9vhp63vjq9cx",
  "hash": "sha256-nSUs9zAX7hQ3PuFrH4zQblMfTY6ALDNggmqaQnkbR5E=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;


  meta = {
    homepage = "https://github.com/MunifTanjim/nui.nvim";
    description = "UI Component Library for Neovim.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

nvim-cmp = callPackage({ buildLuarocksPackage, fetchgit, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "nvim-cmp";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/hrsh7th/nvim-cmp",
  "rev": "0b751f6beef40fd47375eaf53d3057e0bfa317e4",
  "date": "2023-11-06T17:58:22+09:00",
  "path": "/nix/store/4z8lkalcj6sk2s5aw2xcalimh3rcgixj-nvim-cmp",
  "sha256": "1qp7s2iam9zzdlw5sgkk6c623z7vjgga0rcg63ja0f836l90grba",
  "hash": "sha256-auUHEjUDOaDkMI9loN6T+/whDDNzPl04bf+nqqLQ5+I=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/hrsh7th/nvim-cmp";
    description = "A completion plugin for neovim";
    license.fullName = "MIT";
  };
}) {};

nvim-nio = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
buildLuarocksPackage {
  pname = "nvim-nio";
  version = "1.8.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/nvim-nio-1.8.1-1.rockspec";
    sha256 = "0f9ccrli5jcvcyawkjd99nm6himnnnd6z54938rd0wjp21d8s4s9";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neotest/nvim-nio/archive/v1.8.1.zip";
    sha256 = "0zax50chrh7qrgh56avd5ny0lb3i0y906wk13mhbkp9i5d9anw1h";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/nvim-neotest/nvim-nio";
    description = "A library for asynchronous IO in Neovim";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

penlight = callPackage({ buildLuarocksPackage, fetchgit, lua, luaOlder, luafilesystem }:
buildLuarocksPackage {
  pname = "penlight";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/penlight.git",
  "rev": "dc6d19c5c1e1b4ac55b14df17b7645af6b410140",
  "date": "2023-09-21T10:51:09+02:00",
  "path": "/nix/store/vbi0d32mbaqcra3jligv8ajq17m1wxa4-penlight",
  "sha256": "12ppgby8ldh4zxwcr7cknacbdvk30fi92sgyzh1zbgvym4l44g0c",
  "hash": "sha256-DDxCKKl+v/UD/P5pkaIDY+62mLKTncx4/wQ2ivx694o=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luafilesystem ];

  meta = {
    homepage = "https://lunarmodules.github.io/penlight";
    description = "Lua utility libraries loosely based on the Python standard libraries";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT/X11";
  };
}) {};

plenary-nvim = callPackage({ buildLuarocksPackage, fetchgit, lua, luaAtLeast, luaOlder, luassert }:
buildLuarocksPackage {
  pname = "plenary.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/nvim-lua/plenary.nvim",
  "rev": "55d9fe89e33efd26f532ef20223e5f9430c8b0c0",
  "date": "2023-11-30T12:17:20+01:00",
  "path": "/nix/store/wf35h8i4s3fdskvcy376vvzp5gi6s6mx-plenary.nvim",
  "sha256": "1f6vqqafk78njpl47xgsf8p199mmvw4h4b9axab9rl86fdlibikz",
  "hash": "sha256-f8YVaXMG0ZyW6iotAgnftaYULnL69UPolRad6RTG27g=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luassert ];

  meta = {
    homepage = "http://github.com/nvim-lua/plenary.nvim";
    description = "lua functions you don't want to write ";
    license.fullName = "MIT/X11";
  };
}) {};

rapidjson = callPackage({ buildLuarocksPackage, fetchgit, lua, luaOlder }:
buildLuarocksPackage {
  pname = "rapidjson";
  version = "0.7.1-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/xpol/lua-rapidjson",
  "rev": "242b40c8eaceb0cc43bcab88309736461cac1234",
  "date": "2021-04-09T19:59:20+08:00",
  "path": "/nix/store/65l71ph27pmipgrq8j4whg6n8h2avvs4-lua-rapidjson",
  "sha256": "1a6srvximxlh6gjkaj5y86d1kf06pc4gby2r6wpdw2pdac8k7xyb",
  "hash": "sha256-y/czEVPtCt4uN1n49Qi7BrgZmkG+SDXlM5D2GvvO2qg=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/xpol/lua-rapidjson";
    description = "Json module based on the very fast RapidJSON.";
    license.fullName = "MIT";
  };
}) {};

rest-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
buildLuarocksPackage {
  pname = "rest.nvim";
  version = "0.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rest.nvim-0.2-1.rockspec";
    sha256 = "1yq8gx585c10j8kybp20swyv9q0i3lm5k0rrv4bgsbwz3ychn0k1";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/rest-nvim/rest.nvim/archive/0.2.zip";
    sha256 = "0ycjrrl37z465p71bdkas3q2ky1jmgr2cjnirnskdc6wz14wl09g";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/rest-nvim/rest.nvim";
    description = "A fast Neovim http client written in Lua";
    maintainers = with lib.maintainers; [ teto ];
    license.fullName = "MIT";
  };
}) {};

rocks-config-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder, rocks-nvim }:
buildLuarocksPackage {
  pname = "rocks-config.nvim";
  version = "1.2.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rocks-config.nvim-1.2.3-1.rockspec";
    sha256 = "0lwy0fkmrxbnj46jh35i9l1hmfa88a879spmasmh7kw4vpd1bbpr";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorocks/rocks-config.nvim/archive/v1.2.3.zip";
    sha256 = "0byf1q18ykgs3hsz8wyjimkcnq0pl26ikxjlv0ly0acxrg9x9kcp";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua rocks-nvim ];

  meta = {
    homepage = "https://github.com/nvim-neorocks/rocks-config.nvim";
    description = "Allow rocks.nvim to help configure your plugins.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "GPL-3.0";
  };
}) {};

rocks-dev-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder, nvim-nio, rocks-nvim }:
buildLuarocksPackage {
  pname = "rocks-dev.nvim";
  version = "1.1.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rocks-dev.nvim-1.1.2-1.rockspec";
    sha256 = "09yz84akkparvqfsjpslxpv3wzvkjrbqil8fxwl5crffggn5mz1b";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorocks/rocks-dev.nvim/archive/v1.1.2.zip";
    sha256 = "19g8dlz2zch0sz21zm92l6ic81bx68wklidjw94xrjyv26139akc";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua nvim-nio rocks-nvim ];

  meta = {
    homepage = "https://github.com/nvim-neorocks/rocks-dev.nvim";
    description = "A swiss-army knife for testing and developing rocks.nvim modules.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "GPL-3.0";
  };
}) {};

rocks-git-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder, nvim-nio, rocks-nvim }:
buildLuarocksPackage {
  pname = "rocks-git.nvim";
  version = "1.3.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rocks-git.nvim-1.3.0-1.rockspec";
    sha256 = "196wjjdkjgqdx1lj8cxcn1xh6dysn0a0w544yc62vg6h227c6igi";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorocks/rocks-git.nvim/archive/v1.3.0.zip";
    sha256 = "024zvl91ixb25rkpikwcxb73qfd6wsc2a5qwkwfy6sibkff7jgaq";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua nvim-nio rocks-nvim ];

  meta = {
    homepage = "https://github.com/nvim-neorocks/rocks-git.nvim";
    description = "Use rocks.nvim to install plugins from git!";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "GPL-3.0";
  };
}) {};

rocks-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, fidget-nvim, fzy, lua, luaOlder, nvim-nio, toml, toml-edit }:
buildLuarocksPackage {
  pname = "rocks.nvim";
  version = "2.19.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rocks.nvim-2.19.1-1.rockspec";
    sha256 = "1n712a8wqhli2hbq8s6isa9jaxxvqy20737njakqdkakqp2xsdbs";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorocks/rocks.nvim/archive/v2.19.1.zip";
    sha256 = "1n3za055vdi6v1hx72sdrh9dpgs6g58b2haq0ad3q5ncsy951h0q";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ fidget-nvim fzy lua nvim-nio toml toml-edit ];

  meta = {
    homepage = "https://github.com/nvim-neorocks/rocks.nvim";
    description = "Neovim plugin management inspired by Cargo.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "GPL-3.0";
  };
}) {};

rustaceanvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
buildLuarocksPackage {
  pname = "rustaceanvim";
  version = "3.9.6-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rustaceanvim-3.9.6-1.rockspec";
    sha256 = "1wlzqm8x2w9clskj2k9n9i4f0pn17dsp99a3gwwrypdlbvm9x77k";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/mrcjkb/rustaceanvim/archive/3.9.6.zip";
    sha256 = "0qmifxb0xgyym0zbizqds5scy4qrnp0hr17rg0synp2fk5iv6s5b";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mrcjkb/rustaceanvim";
    description = "Supercharge your Rust experience in Neovim! A heavily modified fork of rust-tools.nvim";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "GPL-2.0";
  };
}) {};

say = callPackage({ buildLuarocksPackage, fetchgit, lua, luaOlder }:
buildLuarocksPackage {
  pname = "say";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/say.git",
  "rev": "3e1f783d0aa496eb21d16e85b2235335cb9332df",
  "date": "2023-08-13T02:37:27+03:00",
  "path": "/nix/store/5biavac0k8z0xg4rr3bm8z3kdi8mm8c0-say",
  "sha256": "04dkf0av6n71vmz0h86i5brklvaf9p91lkldn1xldpdr0qqs0x63",
  "hash": "sha256-w3SgMQa53UZ7sI1OGtJNTm068yrRIAh+3eFYsxVwsxE=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://lunarmodules.github.io/say";
    description = "Lua string hashing/indexing library";
    license.fullName = "MIT";
  };
}) {};

serpent = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "serpent";
  version = "0.30-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/serpent-0.30-2.rockspec";
    sha256 = "0v83lr9ars1n0djbh7np8jjqdhhaw0pdy2nkcqzqrhv27rzv494n";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/pkulchenko/serpent",
  "rev": "d78683597606c6e13a1fed039bc91d86eb8f600f",
  "date": "2017-09-01T21:35:14-07:00",
  "path": "/nix/store/z6df44n3p07n4bia7s514vgngbkbpnap-serpent",
  "sha256": "0q80yfrgqgr01qprf0hrp284ngb7fbcq1v9rbzmdkhbm9lpgy8v8",
  "hash": "sha256-aCP/Lk11wdnqXzntgNlyZz1LkLgZApcvDiA//LLzAGE=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/pkulchenko/serpent";
    description = "Lua serializer and pretty printer";
    maintainers = with lib.maintainers; [ lockejan ];
    license.fullName = "MIT";
  };
}) {};

sqlite = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, luv }:
buildLuarocksPackage {
  pname = "sqlite";
  version = "v1.2.2-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/sqlite-v1.2.2-0.rockspec";
    sha256 = "0jxsl9lpxsbzc6s5bwmh27mglkqz1299lz68vfxayvailwl3xbxm";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/tami5/sqlite.lua.git",
  "rev": "6c00ab414dc1b69621b145908c582b747f24b46e",
  "date": "2022-06-17T15:57:13+03:00",
  "path": "/nix/store/637s46bsvsxfnzmy6ygig3y0vqmf3r8p-sqlite.lua",
  "sha256": "0ckifx6xxrannn9szacgiiqjsp4rswghxscdl3s411dhas8djj1m",
  "hash": "sha256-NUjZkFawhUD0oI3pDh/XmVwtcYyPqa+TtVbl3k13cTI=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  propagatedBuildInputs = [ luv ];

  meta = {
    homepage = "https://github.com/tami5/sqlite.lua";
    description = "SQLite/LuaJIT binding and a highly opinionated wrapper for storing, retrieving, caching, and persisting [SQLite] databases";
    license.fullName = "MIT";
  };
}) {};

std-_debug = callPackage({ buildLuarocksPackage, fetchgit, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "std._debug";
  version = "git-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lua-stdlib/_debug.git",
  "rev": "8b80b14bbbe7259a47c160176546bb152bb2d6f1",
  "date": "2023-01-31T16:39:35-07:00",
  "path": "/nix/store/i24iz2hvnjp18iz9z8kljsy9iv17m2zl-_debug",
  "sha256": "07z5lz3gy8wzzks79r3v68vckj42i3sybhfmqx7h2s58ld2kn5fd",
  "hash": "sha256-zRU7RaOoaAFPx9XB5fWIgsjJNjJ75HT0/J8j/8an5R8=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://lua-stdlib.github.io/_debug";
    description = "Debug Hints Library";
    license.fullName = "MIT/X11";
  };
}) {};

std-normalize = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaAtLeast, luaOlder, std-_debug }:
buildLuarocksPackage {
  pname = "std.normalize";
  version = "2.0.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/std.normalize-2.0.3-1.rockspec";
    sha256 = "1l83ikiaw4dch2r69cxpl93b9d4wf54vbjb6fcggnkxxgm0amj3a";
  }).outPath;
  src = fetchzip {
    url    = "http://github.com/lua-stdlib/normalize/archive/v2.0.3.zip";
    sha256 = "1gyywglxd2y7ck3hk8ap73w0x7hf9irpg6vgs8yc6k9k4c5g3fgi";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua std-_debug ];

  meta = {
    homepage = "https://lua-stdlib.github.io/normalize";
    description = "Normalized Lua Functions";
    license.fullName = "MIT/X11";
  };
}) {};

stdlib = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "stdlib";
  version = "41.2.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/stdlib-41.2.2-1.rockspec";
    sha256 = "0rscb4cm8s8bb8fk8rknc269y7bjqpslspsaxgs91i8bvabja6f6";
  }).outPath;
  src = fetchzip {
    url    = "http://github.com/lua-stdlib/lua-stdlib/archive/release-v41.2.2.zip";
    sha256 = "0ry6k0wh4vyar1z68s0qmqzkdkfn9lcznsl8av7x78qz6l16wfw4";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://lua-stdlib.github.io/lua-stdlib";
    description = "General Lua Libraries";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

teal-language-server = callPackage({ buildLuarocksPackage, cyan, dkjson, fetchgit, fetchurl, luafilesystem }:
buildLuarocksPackage {
  pname = "teal-language-server";
  version = "dev-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/teal-language-server-dev-1.rockspec";
    sha256 = "01l44c6bknz7ff9xqgich31hlb0yk4ms5k1hs4rhm3cs95s5vlzc";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://git@github.com/teal-language/teal-language-server.git",
  "rev": "67b5d7cad60b9df472851a2c61591f2aab97da47",
  "date": "2022-12-21T20:33:53-06:00",
  "path": "/nix/store/qyaz38njm8qgyfxca6m6f8i4lkfcfdb0-teal-language-server",
  "sha256": "12nqarykmdvxxci9l6gq2yhn4pjzzqlxyrl2c8svb97hka68wjvx",
  "hash": "sha256-fUuOjJrwpLU1YoJm3yn+X15ioRf4GZoi6323On1W2Io=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  propagatedBuildInputs = [ cyan dkjson luafilesystem ];

  meta = {
    homepage = "https://github.com/teal-language/teal-language-server";
    description = "A language server for the Teal language";
    license.fullName = "MIT";
  };
}) {};

telescope-manix = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder, telescope-nvim }:
buildLuarocksPackage {
  pname = "telescope-manix";
  version = "1.0.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/telescope-manix-1.0.0-1.rockspec";
    sha256 = "0fhcglrnsjyhg1g2ldlb24fck9b5fnzy7kc67yjgkw62d557vjgk";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/mrcjkb/telescope-manix/archive/1.0.0.zip";
    sha256 = "1svw724jlhchsl191bmgr50zbjl9vghkaxk3j8g0nzvrn9677b22";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua telescope-nvim ];

  meta = {
    homepage = "https://github.com/mrcjkb/telescope-manix";
    description = "A telescope.nvim extension for Manix - A fast documentation searcher for Nix";
    license.fullName = "GPL-2.0";
  };
}) {};

telescope-nvim = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, plenary-nvim }:
buildLuarocksPackage {
  pname = "telescope.nvim";
  version = "scm-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/telescope.nvim-scm-1.rockspec";
    sha256 = "07mjkv1nv9b3ifxk2bbpbhvp0awblyklyz6aaqw418x4gm4q1g35";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/nvim-telescope/telescope.nvim",
  "rev": "6213322ab56eb27356fdc09a5078e41e3ea7f3bc",
  "date": "2023-12-06T03:50:38+00:00",
  "path": "/nix/store/h1v5377aylxb6vq8v7m7wrl585vb1dzi-telescope.nvim",
  "sha256": "074bq8p1bkyr12z1wy31bipb97vmqia4lsmdp2aj1v1r5x5ph736",
  "hash": "sha256-Zhx4Sy857CCVuK1qSlTEdZ+0blxheB6+CNnPFS7Cixw=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (lua.luaversion != "5.1");
  propagatedBuildInputs = [ lua plenary-nvim ];

  meta = {
    homepage = "https://github.com/nvim-telescope/telescope.nvim";
    description = "Find, Filter, Preview, Pick. All lua, all the time.";
    license.fullName = "MIT";
  };
}) {};

tiktoken_core = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder, luarocks-build-rust-mlua }:
buildLuarocksPackage {
  pname = "tiktoken_core";
  version = "0.2.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/tiktoken_core-0.2.1-1.rockspec";
    sha256 = "0mdmrpg82vmk0cqiqdayyk4vvl299z0xqrg58q18dfs5nc27wkla";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/gptlang/lua-tiktoken",
  "rev": "61d831a81a01ba095f8c94e148b721b3aa7b1e45",
  "date": "2024-03-03T23:24:06+00:00",
  "path": "/nix/store/5ik17k726wl8hpz295n7dqq3438k8ddj-lua-tiktoken",
  "sha256": "11lpzxmmb4zglkp9czlzggd8i46r7whpq021b5d3fx7bc5a81d3n",
  "hash": "sha256-drSAVGHrdDdaWUEAfCE/2ZCI2nuffpbupO+TVWv/l4Y=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luarocks-build-rust-mlua ];

  meta = {
    homepage = "https://github.com/gptlang/lua-tiktoken";
    description = "An experimental port of OpenAI's Tokenizer to lua";
    maintainers = with lib.maintainers; [ natsukium ];
    license.fullName = "MIT";
  };
}) {};

tl = callPackage({ argparse, buildLuarocksPackage, compat53, fetchgit, fetchurl, luafilesystem }:
buildLuarocksPackage {
  pname = "tl";
  version = "0.15.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/tl-0.15.3-1.rockspec";
    sha256 = "15p67r5bjp997pymjq80yn1gyf7r5g2nwkachkwx88100ihblqrc";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/teal-language/tl",
  "rev": "28f8fd9eb1a756267b8cde25990dfae27f8f5bcc",
  "date": "2023-11-05T23:31:17-03:00",
  "path": "/nix/store/8qbkpkni2ci042ryzjh0nfxnrmmckg3l-tl",
  "sha256": "0spr0zajy8i91n0jqmjpgdcsryrlras6fv60np9ml1rfirh0yk4y",
  "hash": "sha256-nkwPYI4uB1rTtcBsZ7TKNPusWXtXViyBDSkiL9UH+Wo=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  propagatedBuildInputs = [ argparse compat53 luafilesystem ];

  meta = {
    homepage = "https://github.com/teal-language/tl";
    description = "Teal, a typed dialect of Lua";
    maintainers = with lib.maintainers; [ mephistophiles ];
    license.fullName = "MIT";
  };
}) {};

toml = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "toml";
  version = "0.3.0-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/toml-0.3.0-0.rockspec";
    sha256 = "0y4qdzsvf4xwnr49xcpbqclrq9d6snv83cbdkrchl0cn4cx6zpxy";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/LebJe/toml.lua.git",
  "rev": "319e9accf8c5cedf68795354ba81e54c817d1277",
  "date": "2023-02-19T23:00:49-05:00",
  "path": "/nix/store/p6a98sqp9a4jwsw6ghqcwpn9lxmhvkdg-toml.lua",
  "sha256": "05p33bq0ajl41vbsw9bx73shpf0p11n5gb6yy8asvp93zh2m51hq",
  "hash": "sha256-GIZSBfwj3a0V8t6sV2wIF7gL9Th9Ja7XDoRKBfAa4xY=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/LebJe/toml.lua";
    description = "TOML v1.0.0 parser and serializer for Lua. Powered by toml++.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

toml-edit = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder, luarocks-build-rust-mlua }:
buildLuarocksPackage {
  pname = "toml-edit";
  version = "0.1.5-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/toml-edit-0.1.5-1.rockspec";
    sha256 = "1xgjh8x44kn24vc29si811zq2a7pr24zqj4w07pys5k6ccnv26qz";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/vhyrro/toml-edit.lua",
  "rev": "34f072d8ff054b3124d9d2efc0263028d7425525",
  "date": "2023-12-29T15:53:36+01:00",
  "path": "/nix/store/z1gn59hz9ypk3icn3gmafaa19nzx7a1v-toml-edit.lua",
  "sha256": "0jzzp4sd48haq1kmh2k85gkygfq39i10kvgjyqffcrv3frdihxvx",
  "hash": "sha256-fXcYW3ZjZ+Yc9vLtCUJMA7vn5ytoClhnwAoi0jS5/0s=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luarocks-build-rust-mlua ];

  meta = {
    homepage = "https://github.com/vhyrro/toml-edit.lua";
    description = "TOML Parser + Formatting and Comment-Preserving Editor";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

vstruct = callPackage({ buildLuarocksPackage, fetchgit, lua, luaOlder }:
buildLuarocksPackage {
  pname = "vstruct";
  version = "2.1.1-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/ToxicFrog/vstruct.git",
  "rev": "924d3dd63043189e4a7ef6b1b54b19208054cc0f",
  "date": "2020-05-06T23:13:06-04:00",
  "path": "/nix/store/a4i9k5hx9xiz38bij4hb505dg088jkss-vstruct",
  "sha256": "0sl9v874mckhh6jbxsan48s5xajzx193k4qlphw69sdbf8kr3p57",
  "hash": "sha256-p9yRJ3Kr6WQ4vBSTOVLoX6peNCJW6b6kgXCySg7aiWo=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/ToxicFrog/vstruct";
    description = "Lua library to manipulate binary data";
  };
}) {};

vusted = callPackage({ buildLuarocksPackage, busted, fetchgit, fetchurl }:
buildLuarocksPackage {
  pname = "vusted";
  version = "2.3.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/vusted-2.3.3-1.rockspec";
    sha256 = "0h1v9p327yfqnbwi2rw3k47vwbpqx5rn679rfx5dszn3s6wp5g6p";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/notomo/vusted.git",
  "rev": "69a5a5f453cf2fc2984e1ba4eea91384e59f9da1",
  "date": "2023-11-06T21:06:04+09:00",
  "path": "/nix/store/85m6md82nl3jj853s9mhsc4dy0isws8b-vusted",
  "sha256": "012n09hy4q0im2bv0vprkanv6xqdppaz6f7gwp87nxsmk88q8mxv",
  "hash": "sha256-u1eEEZpVd3vQ5e8489W9DXezrZr5brCXqBFg4mECVgQ=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  propagatedBuildInputs = [ busted ];

  meta = {
    homepage = "https://github.com/notomo/vusted";
    description = "`busted` wrapper for testing neovim plugin";
    maintainers = with lib.maintainers; [ figsoda ];
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

xml2lua = callPackage({ buildLuarocksPackage, fetchgit, fetchurl, lua, luaOlder }:
buildLuarocksPackage {
  pname = "xml2lua";
  version = "1.5-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/xml2lua-1.5-2.rockspec";
    sha256 = "1h0zszjzi65jc2rmpam7ai38sx2ph09q66jkik5mgzr6cxm1cm4h";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/manoelcampos/xml2lua",
  "rev": "b24be89a154d49b33295958584944bfd7ba2b24e",
  "date": "2021-07-13T10:22:09-03:00",
  "path": "/nix/store/i5dvpc0mhhw7jbrvg4bsz1scs0kvmx5f-xml2lua",
  "sha256": "1vk3chcpq8b98dss5kwskbzxig58zar0jgi8mizdccw4rx698c44",
  "hash": "sha256-hDCUTM+EM9Z+rCg+CbL6qLzY/5qaz6J1Q2khfBlkY+4=",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path" "sha256"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://manoelcampos.github.io/xml2lua/";
    description = "An XML Parser written entirely in Lua that works for Lua 5.1+";
    license.fullName = "MIT";
  };
}) {};

}
/* GENERATED - do not edit this file */
