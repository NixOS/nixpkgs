/* pkgs/development/lua-modules/generated-packages.nix is an auto-generated file -- DO NOT EDIT!
Regenerate it with:
nixpkgs$ ./maintainers/scripts/update-luarocks-packages

You can customize the generated packages in pkgs/development/lua-modules/overrides.nix
*/

{ stdenv, lib, fetchurl, fetchgit, callPackage, ... } @ args:
final: prev:
{
alt-getopt = callPackage({ luaAtLeast, lua, luaOlder, fetchgit, buildLuarocksPackage }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/cheusov/lua-alt-getopt";
    description = "Process application arguments the same way as getopt_long";
    maintainers = with lib.maintainers; [ arobyn ];
    license.fullName = "MIT/X11";
  };
}) {};

argparse = callPackage({ luaOlder, buildLuarocksPackage, luaAtLeast, lua, fetchgit }:
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

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/luarocks/argparse";
    description = "A feature-rich command-line argument parser";
    license.fullName = "MIT";
  };
}) {};

basexx = callPackage({ buildLuarocksPackage, lua, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "basexx";
  version = "scm-0";
  rockspecDir = "dist";

  src = fetchurl {
    url    = "https://github.com/aiq/basexx/archive/master.tar.gz";
    sha256 = "1x0d24aaj4zld4ifr7mi8zwrym5shsfphmwx5jzw2zg22r6xzlz1";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/aiq/basexx";
    description = "A base2, base16, base32, base64 and base85 library for Lua";
    license.fullName = "MIT";
  };
}) {};

binaryheap = callPackage({ buildLuarocksPackage, lua, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "binaryheap";
  version = "0.4-1";

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

bit32 = callPackage({ fetchgit, buildLuarocksPackage, lua, luaOlder }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.lua.org/manual/5.2/manual.html#6.7";
    description = "Lua 5.2 bit manipulation library";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT/X11";
  };
}) {};

busted = callPackage({ buildLuarocksPackage, luafilesystem, luasystem, fetchgit, luaOlder, lua-term, say, mediator_lua, penlight, luassert, lua_cliargs, lua, dkjson }:
buildLuarocksPackage {
  pname = "busted";
  version = "2.1.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/busted-2.1.1-1.rockspec";
    sha256 = "0f9iz3pa2gmb2vccvygp6zdiji7l8bap0vlgqgrcg331qsrkf70h";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/busted.git",
  "rev": "e3ed48759b625f2e37bf02ccc057b2b98108f108",
  "date": "2022-08-24T17:34:58+03:00",
  "path": "/nix/store/7g9rxkyhabgx0acwmzl4r4xfh193avpw-busted",
  "sha256": "0nab0s5lhk0nhh58c4jspv5sj4g7839gb5q145hrlgbsxqncp8wy",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ dkjson lua lua-term lua_cliargs luafilesystem luassert luasystem mediator_lua penlight say ];

  meta = {
    homepage = "https://lunarmodules.github.io/busted/";
    description = "Elegant Lua unit testing";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

cassowary = callPackage({ buildLuarocksPackage, fetchgit, penlight, luaOlder, lua }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua penlight ];

  meta = {
    homepage = "https://github.com/sile-typesetter/cassowary.lua";
    description = "The cassowary constraint solver";
    maintainers = with lib.maintainers; [ marsam alerque ];
    license.fullName = "Apache 2";
  };
}) {};

cldr = callPackage({ penlight, luaOlder, lua, fetchgit, buildLuarocksPackage }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua penlight ];

  meta = {
    homepage = "https://github.com/alerque/cldr-lua";
    description = "Lua interface to Unicode CLDR data";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT/ICU";
  };
}) {};

compat53 = callPackage({ lua, luaAtLeast, fetchzip, luaOlder, buildLuarocksPackage }:
buildLuarocksPackage {
  pname = "compat53";
  version = "0.7-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/compat53-0.7-1.rockspec";
    sha256 = "1r7a3q1cjrcmdycrv2ikgl83irjhxs53sa88v2fdpr9aaamlb101";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/keplerproject/lua-compat-5.3/archive/v0.7.zip";
    sha256 = "02a14nvn7aggg1yikj9h3dcf8aqjbxlws1bfvqbpfxv9d5phnrpz";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/keplerproject/lua-compat-5.3";
    description = "Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT";
  };
}) {};

cosmo = callPackage({ buildLuarocksPackage, fetchgit, lpeg }:
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

coxpcall = callPackage({ buildLuarocksPackage, fetchgit }:
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

cqueues = callPackage({ fetchurl, buildLuarocksPackage, lua }:
buildLuarocksPackage {
  pname = "cqueues";
  version = "20200726.52-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cqueues-20200726.52-0.rockspec";
    sha256 = "0w2kq9w0wda56k02rjmvmzccz6bc3mn70s9v7npjadh85i5zlhhp";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/wahern/cqueues/archive/rel-20200726.tar.gz";
    sha256 = "0lhd02ag3r1sxr2hx847rdjkddm04l1vf5234v5cz9bd4kfjw4cy";
  };

  disabled = (lua.luaversion != "5.2");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://25thandclement.com/~william/projects/cqueues.html";
    description = "Continuation Queues: Embeddable asynchronous networking, threading, and notification framework for Lua on Unix.";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT/X11";
  };
}) {};

cyan = callPackage({ argparse, buildLuarocksPackage, tl, fetchgit, luafilesystem }:
buildLuarocksPackage {
  pname = "cyan";
  version = "0.3.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cyan-0.3.0-1.rockspec";
    sha256 = "1bs5gwgdhibj2gm8y3810b0hh6s9n00fgij8nnjag9kpqrd80vsj";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/teal-language/cyan",
  "rev": "31c9eccfc5bf26725e4e8a76ff5d5beaa175da8d",
  "date": "2023-02-19T18:58:20-06:00",
  "path": "/nix/store/smpj81z2a2blb3qfpjwx9n52d50rp39w-cyan",
  "sha256": "0pskargvjn2phgz481b08ndhp3z23s7lqfs8qlwailr7a4f2fc7h",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  propagatedBuildInputs = [ argparse luafilesystem tl ];

  meta = {
    homepage = "https://github.com/teal-language/cyan";
    description = "A build system for the Teal language";
    license.fullName = "MIT";
  };
}) {};

cyrussasl = callPackage({ lua, luaOlder, buildLuarocksPackage, fetchgit }:
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

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/JorjBauer/lua-cyrussasl";
    description = "Cyrus SASL library for Lua 5.1+";
    license.fullName = "BSD";
  };
}) {};

digestif = callPackage({ luafilesystem, fetchgit, lpeg, lua, buildLuarocksPackage, luaOlder }:
buildLuarocksPackage {
  pname = "digestif";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/astoff/digestif",
  "rev": "8f8448fa3f27611b32fe6398fe22ef24b8602ec9",
  "date": "2023-02-24T22:38:11+01:00",
  "path": "/nix/store/s7wxqcj3k8pgb3m86d8rs2ggpl63jxwn-digestif",
  "sha256": "0k3srmilrz3ajj76kklksmifkgqrm0y7gr25h0vrrldrf1xp4pk0",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.3");
  propagatedBuildInputs = [ lpeg lua luafilesystem ];

  meta = {
    homepage = "https://github.com/astoff/digestif/";
    description = "A code analyzer for TeX";
    license.fullName = "GPLv3+ and other free licenses";
  };
}) {};

dkjson = callPackage({ buildLuarocksPackage, lua, luaAtLeast, luaOlder, fetchurl }:
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

fennel = callPackage({ luaOlder, buildLuarocksPackage, fetchurl, lua }:
buildLuarocksPackage {
  pname = "fennel";
  version = "1.3.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/fennel-1.3.0-1.rockspec";
    sha256 = "1by78423n8k8i5sz7ji6w5igm8jkmyvd5x1y519hzmknphjqa263";
  }).outPath;
  src = fetchurl {
    url    = "https://fennel-lang.org/downloads/fennel-1.3.0.tar.gz";
    sha256 = "0m754c74pj10c1qmc4zl89ifjiqcwafn8qagzfpfmcqv6r46pr23";
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

fifo = callPackage({ fetchzip, lua, buildLuarocksPackage }:
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

fluent = callPackage({ lua, luaepnf, fetchgit, cldr, buildLuarocksPackage, penlight, luaOlder }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ cldr lua luaepnf penlight ];

  meta = {
    homepage = "https://github.com/alerque/fluent-lua";
    description = "Lua implementation of Project Fluent";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT";
  };
}) {};

gitsigns-nvim = callPackage({ lua, fetchgit, buildLuarocksPackage }:
buildLuarocksPackage {
  pname = "gitsigns.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lewis6991/gitsigns.nvim",
  "rev": "f388995990aba04cfdc7c3ab870c33e280601109",
  "date": "2023-02-16T11:22:47+00:00",
  "path": "/nix/store/i4acpc5h3sv909gyppm1qv2vqjq84xs1-gitsigns.nvim",
  "sha256": "1nm1f1d8c632nfnkiak4j7ynyin379bmhag5qp2p912cd9cjvsgx",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (lua.luaversion != "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/lewis6991/gitsigns.nvim";
    description = "Git signs written in pure lua";
    license.fullName = "MIT/X11";
  };
}) {};

haskell-tools-nvim = callPackage({ plenary-nvim, fetchzip, lua, luaOlder, buildLuarocksPackage }:
buildLuarocksPackage {
  pname = "haskell-tools.nvim";
  version = "2.3.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/haskell-tools.nvim-2.3.0-1.rockspec";
    sha256 = "0jcmb0hzyhq14b2xcwdhwr9a9wbmfaw27vzfzkv52is24mwfr0p0";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/mrcjkb/haskell-tools.nvim/archive/2.3.0.zip";
    sha256 = "0lg8g2j9fbikgmhimvz9d0yb63csn85racc09qyszba2kviipr24";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua plenary-nvim ];

  meta = {
    homepage = "https://github.com/mrcjkb/haskell-tools.nvim";
    description = "Supercharge your Haskell experience in neovim!";
    license.fullName = "GPL-2.0";
  };
}) {};

http = callPackage({ luaossl, lpeg_patterns, lpeg, binaryheap, compat53, cqueues, bit32, basexx, fetchzip, lua, fifo, luaOlder, buildLuarocksPackage }:
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

inspect = callPackage({ fetchurl, buildLuarocksPackage, lua, luaOlder }:
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

jsregexp = callPackage({ buildLuarocksPackage, lua, luaOlder, fetchgit }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/kmarius/jsregexp";
    description = "javascript (ECMA19) regular expressions for lua";
    license.fullName = "MIT";
  };
}) {};

ldbus = callPackage({ luaOlder, fetchgit, lua, luaAtLeast, buildLuarocksPackage }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/daurnimator/ldbus";
    description = "A Lua library to access dbus.";
    license.fullName = "MIT/X11";
  };
}) {};

ldoc = callPackage({ fetchgit, buildLuarocksPackage, markdown, penlight }:
buildLuarocksPackage {
  pname = "ldoc";
  version = "scm-3";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/stevedonovan/LDoc.git",
  "rev": "01d648f4ad50c3d14f2acadee6acb26beda56990",
  "date": "2022-11-18T00:01:45+01:00",
  "path": "/nix/store/m7vvl2b5k69jrb88d0y60f2y4ryazkp9-LDoc",
  "sha256": "1kl0ba9mnd7nksakzb3vwr0hkkkgyk92v93r2w9xnrq879dhy5mm",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  propagatedBuildInputs = [ markdown penlight ];

  meta = {
    homepage = "https://github.com/lunarmodules/LDoc";
    description = "A Lua Documentation Tool";
    license.fullName = "MIT/X11";
  };
}) {};

lgi = callPackage({ luaOlder, fetchgit, buildLuarocksPackage, lua }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/pavouk/lgi";
    description = "Lua bindings to GObject libraries";
    license.fullName = "MIT/X11";
  };
}) {};

linenoise = callPackage({ buildLuarocksPackage, lua, fetchurl, luaOlder }:
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

ljsyscall = callPackage({ lua, fetchurl, buildLuarocksPackage }:
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

lmathx = callPackage({ fetchurl, buildLuarocksPackage, lua }:
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

lmpfrlib = callPackage({ buildLuarocksPackage, fetchurl, luaAtLeast, lua, luaOlder }:
buildLuarocksPackage {
  pname = "lmpfrlib";
  version = "20170112-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lmpfrlib-20170112-2.rockspec";
    sha256 = "1x7qiwmk5b9fi87fn7yvivdsis8h9fk9r3ipqiry5ahx72vzdm7d";
  }).outPath;
  src = fetchurl {
    url    = "http://www.circuitwizard.de/lmpfrlib/lmpfrlib.c";
    sha256 = "00d32cwvk298k3vyrjkdmfjgc69x1fwyks3hs7dqr2514zdhgssm";
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

loadkit = callPackage({ luaOlder, lua, buildLuarocksPackage, fetchgit }:
buildLuarocksPackage {
  pname = "loadkit";
  version = "1.1.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/loadkit-1.1.0-1.rockspec";
    sha256 = "08fx0xh90r2zvjlfjkyrnw2p95xk1a0qgvlnq4siwdb2mm6fq12l";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/leafo/loadkit.git",
  "rev": "c6c712dab45f6c568821f9ed7b49c790a44d12e7",
  "date": "2021-01-07T14:41:10-08:00",
  "path": "/nix/store/xvwq7b2za8ciww1gjw7vnspg9183xmfa-loadkit",
  "sha256": "15znriijs7izf9f6vmhr6dnvw3pzr0yr0mh6ah41fmdwjqi7jzcz",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/leafo/loadkit";
    description = "Loadkit allows you to load arbitrary files within the Lua package path";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT";
  };
}) {};

lpeg = callPackage({ luaOlder, buildLuarocksPackage, fetchurl, lua }:
buildLuarocksPackage {
  pname = "lpeg";
  version = "1.0.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lpeg-1.0.2-1.rockspec";
    sha256 = "08a8p5cwlwpjawk8sczb7bq2whdsng4mmhphahyklf1bkvl2li89";
  }).outPath;
  src = fetchurl {
    url    = "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.2.tar.gz";
    sha256 = "1zjzl7acvcdavmcg5l7wi12jd4rh95q9pl5aiww7hv0v0mv6bmj8";
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

lpeg_patterns = callPackage({ lpeg, fetchzip, buildLuarocksPackage, lua }:
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

lpeglabel = callPackage({ fetchurl, lua, luaOlder, buildLuarocksPackage }:
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

lpty = callPackage({ luaOlder, lua, fetchurl, buildLuarocksPackage }:
buildLuarocksPackage {
  pname = "lpty";
  version = "1.2.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lpty-1.2.2-1.rockspec";
    sha256 = "04af4mhiqrw3br4qzz7yznw9zy2m50wddwzgvzkvhd99ng71fkzg";
  }).outPath;
  src = fetchurl {
    url    = "http://www.tset.de/downloads/lpty-1.2.2-1.tar.gz";
    sha256 = "071mvz79wi9vr6hvrnb1rv19lqp1bh2fi742zkpv2sm1r9gy5rav";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.tset.de/lpty/";
    description = "A simple facility for lua to control other programs via PTYs.";
    license.fullName = "MIT";
  };
}) {};

lrexlib-gnu = callPackage({ buildLuarocksPackage, luaOlder, lua, fetchgit }:
buildLuarocksPackage {
  pname = "lrexlib-gnu";
  version = "2.9.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lrexlib-gnu-2.9.1-1.rockspec";
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

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (GNU flavour).";
    license.fullName = "MIT/X11";
  };
}) {};

lrexlib-pcre = callPackage({ lua, luaOlder, buildLuarocksPackage, fetchgit }:
buildLuarocksPackage {
  pname = "lrexlib-pcre";
  version = "2.9.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lrexlib-pcre-2.9.1-1.rockspec";
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

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (PCRE flavour).";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

lrexlib-posix = callPackage({ lua, luaOlder, buildLuarocksPackage, fetchgit }:
buildLuarocksPackage {
  pname = "lrexlib-posix";
  version = "2.9.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lrexlib-posix-2.9.1-1.rockspec";
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

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (POSIX flavour).";
    license.fullName = "MIT/X11";
  };
}) {};

lua-cjson = callPackage({ luaOlder, fetchgit, lua, buildLuarocksPackage }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.kyne.com.au/~mark/software/lua-cjson.php";
    description = "A fast JSON encoding/parsing module";
    license.fullName = "MIT";
  };
}) {};

lua-cmsgpack = callPackage({ luaOlder, fetchgit, lua, buildLuarocksPackage }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/antirez/lua-cmsgpack";
    description = "MessagePack C implementation and bindings for Lua 5.1/5.2/5.3";
    license.fullName = "Two-clause BSD";
  };
}) {};

lua-curl = callPackage({ lua, buildLuarocksPackage, fetchzip, luaOlder, luaAtLeast }:
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

lua-iconv = callPackage({ fetchurl, lua, buildLuarocksPackage, luaOlder }:
buildLuarocksPackage {
  pname = "lua-iconv";
  version = "7-3";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-iconv-7-3.rockspec";
    sha256 = "0qh5vsaxd7s31p7a8rl08lwd6zv90wnvp15nll4fcz452kffpp72";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/downloads/ittner/lua-iconv/lua-iconv-7.tar.gz";
    sha256 = "02dg5x79fg5mwsycr0fj6w04zykdpiki9xjswkkwzdalqwaikny1";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://ittner.github.com/lua-iconv/";
    description = "Lua binding to the iconv";
    license.fullName = "MIT/X11";
  };
}) {};

lua-lsp = callPackage({ fetchgit, inspect, lua, lpeglabel, dkjson, luaAtLeast, luaOlder, buildLuarocksPackage }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ dkjson inspect lpeglabel lua ];

  meta = {
    homepage = "https://github.com/Alloyed/lua-lsp";
    description = "A Language Server implementation for lua, the language";
    license.fullName = "MIT";
  };
}) {};

lua-messagepack = callPackage({ buildLuarocksPackage, lua, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-messagepack";
  version = "0.5.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-messagepack-0.5.2-1.rockspec";
    sha256 = "15liz6v8hsqgb3xrcd74a71nnjcz79gpc3ak351hk6k4gyjq2rfc";
  }).outPath;
  src = fetchurl {
    url    = "https://framagit.org/fperrad/lua-MessagePack/raw/releases/lua-messagepack-0.5.2.tar.gz";
    sha256 = "1jgi944d0vx4zs9lrphys9pw0wrsibip93sh141qjwymrjyjg1nc";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://fperrad.frama.io/lua-MessagePack/";
    description = "a pure Lua implementation of the MessagePack serialization format";
    license.fullName = "MIT/X11";
  };
}) {};

lua-protobuf = callPackage({ luaOlder, buildLuarocksPackage, lua, fetchgit }:
buildLuarocksPackage {
  pname = "lua-protobuf";
  version = "0.4.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-protobuf-0.4.1-1.rockspec";
    sha256 = "0b395lhby26drb8dzf2gn2avlwvxmnaqmqx5m4g3ik7dmmn7p09i";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/starwing/lua-protobuf.git",
  "rev": "2a2b0b95117642ad9470bfe0add7dd6ce82f3869",
  "date": "2022-11-29T21:34:24+08:00",
  "path": "/nix/store/8yjzfj6gy8nkz1dxf0bmy8afwiv8gsjr-lua-protobuf",
  "sha256": "0c1vjji0nj9lznsxw5gbnhab0ibs69298yrsn5yky0hhz8mmx5nr",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/starwing/lua-protobuf";
    description = "protobuf data support for Lua";
    maintainers = with lib.maintainers; [ lockejan ];
    license.fullName = "MIT";
  };
}) {};

lua-resty-http = callPackage({ lua, fetchgit, luaOlder, buildLuarocksPackage }:
buildLuarocksPackage {
  pname = "lua-resty-http";
  version = "0.17.0.beta.1-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-http-0.17.0.beta.1-0.rockspec";
    sha256 = "1cjl007k43cyrwvj0p58hvp00q4lnd9rq3v3pcvwi5an2pvxnv80";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/ledgetech/lua-resty-http",
  "rev": "8cb73c4cc2118f0c62d9132e3b3b14aa36192e34",
  "date": "2022-02-11T16:44:50+00:00",
  "path": "/nix/store/29kr6whllphz0nla5nh1f8q30dgp9vnz-lua-resty-http",
  "sha256": "0y253dnnx59a5c1nbkcv1p5kq7kdsd5i094i7wzpg5ar6xwvqhjb",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/ledgetech/lua-resty-http";
    description = "Lua HTTP client cosocket driver for OpenResty / ngx_lua.";
    license.fullName = "2-clause BSD";
  };
}) {};

lua-resty-jwt = callPackage({ luaOlder, lua-resty-openssl, fetchgit, lua, buildLuarocksPackage }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua-resty-openssl ];

  meta = {
    homepage = "https://github.com/cdbattags/lua-resty-jwt";
    description = "JWT for ngx_lua and LuaJIT.";
    license.fullName = "Apache License Version 2";
  };
}) {};

lua-resty-openidc = callPackage({ lua-resty-http, buildLuarocksPackage, fetchgit, lua-resty-session, luaOlder, lua, lua-resty-jwt }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua-resty-http lua-resty-jwt lua-resty-session ];

  meta = {
    homepage = "https://github.com/zmartzone/lua-resty-openidc";
    description = "A library for NGINX implementing the OpenID Connect Relying Party (RP) and the OAuth 2.0 Resource Server (RS) functionality";
    license.fullName = "Apache 2.0";
  };
}) {};

lua-resty-openssl = callPackage({ fetchgit, buildLuarocksPackage }:
buildLuarocksPackage {
  pname = "lua-resty-openssl";
  version = "0.8.17-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-openssl-0.8.17-1.rockspec";
    sha256 = "1b4dv9mdb90n0f6982pnjb05rgb12nkn1j66a1ywcs5fqcmj4sb5";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/fffonion/lua-resty-openssl.git",
  "rev": "dc17f6b2ff3adaa3bcb586f1d09073a4f4f4ec9d",
  "date": "2023-01-20T01:36:57+08:00",
  "path": "/nix/store/hh9i8ndb861iplkf9mz6vs2akkyibazn-lua-resty-openssl",
  "sha256": "14xmxskbw3clqr97y69d311rs6i97vl7dg8pzixsqf4ypgllzvig",
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

lua-resty-session = callPackage({ buildLuarocksPackage, fetchgit, luaOlder, lua, lua-resty-openssl /*, lua_pack, lua-ffi-zlib */  }:
buildLuarocksPackage {
  pname = "lua-resty-session";
  version = "4.0.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-session-4.0.3-1.rockspec";
    sha256 = "17q8gf0zjdbfgphvjsnlzw1d6158v4ppiqxap6hjqr0prqa5yyfq";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/bungle/lua-resty-session.git",
  "rev": "3373d8138930b6d1e255bb80d9127503019301d7",
  "date": "2023-02-21T20:52:32+02:00",
  "path": "/nix/store/pdwd03w7505wkv4fw79a3mdlfijk9ngd-lua-resty-session",
  "sha256": "1d105785jzn9x3by4r0baaffr5xmc2ilgd7z7izcwq9z29pnfv02",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua-resty-openssl /* lua_pack lua-ffi-zlib */ ];

  meta = {
    homepage = "https://github.com/bungle/lua-resty-session";
    description = "Session Library for OpenResty - Flexible and Secure";
    license.fullName = "BSD";
    broken = true; # lua_pack and lua-ffi-zlib are unpackaged, causing this package to not evaluate
  };
}) {};

lua-subprocess = callPackage({ lua, buildLuarocksPackage, fetchgit, luaOlder }:
buildLuarocksPackage {
  pname = "subprocess";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/0x0ade/lua-subprocess.git",
  "rev": "bfa8e97da774141f301cfd1106dca53a30a4de54",
  "date": "2021-01-09T22:31:54+01:00",
  "path": "/nix/store/3lr7n1k85kbf718wxr51xd40i8dfs5qd-lua-subprocess",
  "sha256": "0p91hda0b0hpgdbff5drcyygaizq086gw8vnvzn0y0fg3mc9if70",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/xlq/lua-subprocess";
    description = "A Lua module written in C that allows you to create child processes and communicate with them.";
    maintainers = with lib.maintainers; [ scoder12 ];
    license.fullName = "MIT";
  };
}) {};

lua-term = callPackage({ fetchurl, buildLuarocksPackage }:
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

lua-toml = callPackage({ fetchgit, buildLuarocksPackage, luaOlder, lua }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/jonstoler/lua-toml";
    description = "toml decoder/encoder for Lua";
    license.fullName = "MIT";
  };
}) {};

lua-yajl = callPackage({ luaOlder, buildLuarocksPackage, lua, fetchgit }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/brimworks/lua-yajl";
    description = "Integrate the yajl JSON library with Lua.";
    maintainers = with lib.maintainers; [ pstn ];
    license.fullName = "MIT/X11";
  };
}) {};

lua-zlib = callPackage({ fetchgit, buildLuarocksPackage, luaOlder, lua }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/brimworks/lua-zlib";
    description = "Simple streaming interface to zlib for Lua.";
    maintainers = with lib.maintainers; [ koral ];
    license.fullName = "MIT";
  };
}) {};

lua_cliargs = callPackage({ lua, luaOlder, buildLuarocksPackage, fetchurl }:
buildLuarocksPackage {
  pname = "lua_cliargs";
  version = "3.0-2";

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

luabitop = callPackage({ luaAtLeast, lua, fetchgit, buildLuarocksPackage, luaOlder }:
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

  disabled = (luaOlder "5.1") || (luaAtLeast "5.3");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://bitop.luajit.org/";
    description = "Lua Bit Operations Module";
    license.fullName = "MIT/X license";
  };
}) {};

luacheck = callPackage({ argparse, luafilesystem, lua, luaOlder, fetchgit, buildLuarocksPackage }:
buildLuarocksPackage {
  pname = "luacheck";
  version = "1.1.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luacheck-1.1.0-1.rockspec";
    sha256 = "1r8d02x0hw28rd5p2gr7sf503lczjxv6qk1q66b375ibx6smpyza";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/luacheck.git",
  "rev": "fcbdeacad00e643e0d78c56b9ba6d8b3c7fa584f",
  "date": "2022-12-19T20:51:56+03:00",
  "path": "/nix/store/srzi8dfrbb9gby9lc7r4sndzzrpzd7nm-luacheck",
  "sha256": "0bkbcxadlf0j59lyvadp7hs7l107blkci15i0hrbi72bx18hj99h",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ argparse lua luafilesystem ];

  meta = {
    homepage = "https://github.com/lunarmodules/luacheck";
    description = "A static analyzer and a linter for Lua";
    license.fullName = "MIT";
  };
}) {};

luacov = callPackage({ luaAtLeast, buildLuarocksPackage, luaOlder, lua, fetchgit }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://keplerproject.github.io/luacov/";
    description = "Coverage analysis tool for Lua scripts";
    license.fullName = "MIT";
  };
}) {};

luadbi = callPackage({ buildLuarocksPackage, lua, luaOlder, fetchgit, luaAtLeast }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-mysql = callPackage({ luaOlder, lua, buildLuarocksPackage, fetchgit, luadbi, luaAtLeast }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-postgresql = callPackage({ lua, fetchgit, buildLuarocksPackage, luaOlder, luaAtLeast, luadbi }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-sqlite3 = callPackage({ luaAtLeast, lua, luaOlder, buildLuarocksPackage, fetchgit, luadbi }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luaepnf = callPackage({ luaOlder, buildLuarocksPackage, lpeg, luaAtLeast, lua, fetchgit }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lpeg lua ];

  meta = {
    homepage = "http://siffiejoe.github.io/lua-luaepnf/";
    description = "Extended PEG Notation Format (easy grammars for LPeg)";
    license.fullName = "MIT";
  };
}) {};

luaevent = callPackage({ lua, fetchurl, luaOlder, buildLuarocksPackage }:
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

luaexpat = callPackage({ buildLuarocksPackage, fetchgit, luaOlder, lua }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://lunarmodules.github.io/luaexpat";
    description = "XML Expat parsing";
    maintainers = with lib.maintainers; [ arobyn flosse ];
    license.fullName = "MIT/X11";
  };
}) {};

luaffi = callPackage({ fetchgit, buildLuarocksPackage, lua, luaOlder }:
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

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/facebook/luaffifb";
    description = "FFI library for calling C functions from lua";
    license.fullName = "BSD";
  };
}) {};

luafilesystem = callPackage({ luaOlder, lua, fetchgit, buildLuarocksPackage }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "git://github.com/keplerproject/luafilesystem";
    description = "File System Library for the Lua Programming Language";
    maintainers = with lib.maintainers; [ flosse ];
    license.fullName = "MIT/X11";
  };
}) {};

lualdap = callPackage({ fetchgit, lua, luaOlder, buildLuarocksPackage }:
buildLuarocksPackage {
  pname = "lualdap";
  version = "1.3.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lualdap-1.3.0-1.rockspec";
    sha256 = "0b51sm0fz4kiim20w538v31k9g20wq3msxdkh17drkr60ab25sc8";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lualdap/lualdap",
  "rev": "be380f5d98f779c813a4fb4ae1400262366fc8d4",
  "date": "2021-06-05T15:49:42+02:00",
  "path": "/nix/store/99sy73yz6sidqhkl0kwdsd7r853aw38n-lualdap",
  "sha256": "133d8br5f24z03ni38m0czrqfz0mr0ksdrc1g73rawpmiqarpps8",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://lualdap.github.io/lualdap/";
    description = "A Lua interface to the OpenLDAP library";
    maintainers = with lib.maintainers; [ aanderse ];
    license.fullName = "MIT";
  };
}) {};

lualogging = callPackage({ luasocket, buildLuarocksPackage, fetchgit }:
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

luaossl = callPackage({ buildLuarocksPackage, lua, fetchzip }:
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

luaposix = callPackage({ bit32, lua, luaOlder, fetchzip, luaAtLeast, buildLuarocksPackage }:
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

luarepl = callPackage({ buildLuarocksPackage, fetchurl, luaOlder, lua }:
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

luasec = callPackage({ fetchgit, luaOlder, luasocket, buildLuarocksPackage, lua }:
buildLuarocksPackage {
  pname = "luasec";
  version = "1.2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasec-1.2.0-1.rockspec";
    sha256 = "0zavdkwd701j8zqyzrpn1n5xd242vziq2l79amjdn5mcw81nrsdf";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/brunoos/luasec",
  "rev": "d9215ee00f6694a228daad50ee85827a4cd13583",
  "date": "2022-07-30T08:42:53-03:00",
  "path": "/nix/store/77m3g768a230h77nxiw23ay73aryq1zh-luasec",
  "sha256": "1rz2lhf243lrsjsyjwxhijhqr88l8l8sndzzv9w4x1j0zpa9sblb",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luasocket ];

  meta = {
    homepage = "https://github.com/brunoos/luasec/wiki";
    description = "A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket.";
    maintainers = with lib.maintainers; [ flosse ];
    license.fullName = "MIT";
  };
}) {};

luasocket = callPackage({ fetchgit, lua, luaOlder, buildLuarocksPackage }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/lunarmodules/luasocket";
    description = "Network support for the Lua language";
    license.fullName = "MIT";
  };
}) {};

luasql-sqlite3 = callPackage({ lua, buildLuarocksPackage, fetchgit, luaOlder }:
buildLuarocksPackage {
  pname = "luasql-sqlite3";
  version = "2.6.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasql-sqlite3-2.6.0-1.rockspec";
    sha256 = "0w32znsfcaklcja6avqx7daaxbf0hr2v8g8bmz0fysb3401lmp02";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/luasql.git",
  "rev": "e2660cbaeb13cb33d8346bb816c6a526241b3c2d",
  "date": "2022-10-03T18:44:40-03:00",
  "path": "/nix/store/mxzq779w3l19bgb424aa4cqdzxczmwr3-luasql",
  "sha256": "052hc174am05plidilzf36vr736sp8vyydfb12qa8xr6mk74f6d1",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.keplerproject.org/luasql/";
    description = "Database connectivity for Lua (SQLite3 driver)";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

luassert = callPackage({ luaOlder, fetchgit, buildLuarocksPackage, lua, say }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua say ];

  meta = {
    homepage = "https://lunarmodules.github.io/busted/";
    description = "Lua assertions extension";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

luasystem = callPackage({ buildLuarocksPackage, luaOlder, lua, fetchurl }:
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

luaunbound = callPackage({ fetchurl, lua, buildLuarocksPackage, luaOlder, luaAtLeast }:
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

luaunit = callPackage({ buildLuarocksPackage, fetchzip, lua, luaAtLeast, luaOlder }:
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

luautf8 = callPackage({ fetchurl, buildLuarocksPackage, lua, luaOlder }:
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

luazip = callPackage({ luaOlder, luaAtLeast, buildLuarocksPackage, lua, fetchgit }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mpeterv/luazip";
    description = "Library for reading files inside zip files";
    license.fullName = "MIT";
  };
}) {};

lush-nvim = callPackage({ buildLuarocksPackage, fetchgit, luaAtLeast, luaOlder, lua }:
buildLuarocksPackage {
  pname = "lush.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/rktjmp/lush.nvim",
  "rev": "b1e8eb1da3fee95ef31515a73c9eff9bf251088d",
  "date": "2023-01-03T10:45:29+11:00",
  "path": "/nix/store/wpnvi5bjlp7sl8g2li21qkcd7m1f3d3w-lush.nvim",
  "sha256": "0q3prq4fm9rpczl7b1lgqnhs0z5jgvpdy0cp45jfpw4bvcy6vkpq",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/rktjmp/lush.nvim";
    description = "Define Neovim themes as a DSL in lua, with real-time feedback.";
    maintainers = with lib.maintainers; [ teto ];
    license.fullName = "MIT/X11";
  };
}) {};

luuid = callPackage({ luaOlder, luaAtLeast, buildLuarocksPackage, fetchurl, lua }:
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

luv = callPackage({ luaOlder, buildLuarocksPackage, fetchurl, lua }:
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

lyaml = callPackage({ buildLuarocksPackage, fetchzip, lua, luaOlder, luaAtLeast }:
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

magick = callPackage({ fetchgit, buildLuarocksPackage, lua }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (lua.luaversion != "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "git://github.com/leafo/magick.git";
    description = "Lua bindings to ImageMagick & GraphicsMagick for LuaJIT using FFI";
    license.fullName = "MIT";
  };
}) {};

markdown = callPackage({ buildLuarocksPackage, luaAtLeast, fetchgit, luaOlder, lua }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mpeterv/markdown";
    description = "Markdown text-to-html markup system.";
    license.fullName = "MIT/X11";
  };
}) {};

mediator_lua = callPackage({ luaOlder, lua, fetchurl, buildLuarocksPackage }:
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

moonscript = callPackage({ lpeg, luaOlder, fetchgit, lua, buildLuarocksPackage, argparse, luafilesystem }:
buildLuarocksPackage {
  pname = "moonscript";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/leafo/moonscript.git",
  "rev": "a0108328373d5f3f1aefb98341aa895dd75a1b2a",
  "date": "2022-11-04T13:38:05-07:00",
  "path": "/nix/store/js597jw44cdfq154a7bpqba99ninzsqh-moonscript",
  "sha256": "02ig93c1dzrbs64mz40bkzz3p93fdxm6m0i7gfqwiickybr9wd97",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

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
  version = "1.0.9-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/mpack-1.0.9-0.rockspec";
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

nvim-client = callPackage({ coxpcall, fetchurl, mpack, lua, luaOlder, luv, buildLuarocksPackage }:
buildLuarocksPackage {
  pname = "nvim-client";
  version = "0.2.4-1";

  src = fetchurl {
    url    = "https://github.com/neovim/lua-client/archive/0.2.4-1.tar.gz";
    sha256 = "0sk1lmj0r7pyj9k3p6n0wqjbd95br44ansz0ck3amp6ql8f9kprf";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ coxpcall lua luv mpack ];

  meta = {
    homepage = "https://github.com/neovim/lua-client";
    description = "Lua client to Nvim";
    license.fullName = "Apache";
  };
}) {};

nvim-cmp = callPackage({ luaAtLeast, lua, fetchgit, buildLuarocksPackage, luaOlder }:
buildLuarocksPackage {
  pname = "nvim-cmp";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/hrsh7th/nvim-cmp",
  "rev": "7a3b1e76f74934b12fda82158237c6ad8bfd3d40",
  "date": "2023-02-24T12:23:36+09:00",
  "path": "/nix/store/s1qark9y2zkbwyl2mzg60z9r0h4hajf4-nvim-cmp",
  "sha256": "0cy93aj02nkspr83sqsrix12jcnhkl5s2mbpjr5ffhpcrk19vlmx",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/hrsh7th/nvim-cmp";
    description = "A completion plugin for neovim";
    license.fullName = "MIT";
  };
}) {};

penlight = callPackage({ luafilesystem, luaOlder, fetchgit, buildLuarocksPackage, lua }:
buildLuarocksPackage {
  pname = "penlight";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/penlight.git",
  "rev": "7e67bcb1c4d95e7ca817356533419b4a72049b96",
  "date": "2022-12-28T23:34:46+01:00",
  "path": "/nix/store/14kax7nswd7in005cgb0f0r8194s9nsd-penlight",
  "sha256": "17gcfi8hqpdp8m0f1nr9n5p1mzxxpq2qwf8zkqvjkb7qv1zqabj1",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luafilesystem ];

  meta = {
    homepage = "https://lunarmodules.github.io/penlight";
    description = "Lua utility libraries loosely based on the Python standard libraries";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT/X11";
  };
}) {};

plenary-nvim = callPackage({ lua, fetchgit, luaOlder, luaAtLeast, luassert, buildLuarocksPackage }:
buildLuarocksPackage {
  pname = "plenary.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/nvim-lua/plenary.nvim",
  "rev": "253d34830709d690f013daf2853a9d21ad7accab",
  "date": "2023-02-19T10:05:49+01:00",
  "path": "/nix/store/dnzlin3gqpvd35a8c5g5hwg3fl28vxgs-plenary.nvim",
  "sha256": "17vvl06jc5vrfrv7gljflkqykshhg84wnhbl9br4pm050ywlg4ng",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luassert ];

  meta = {
    homepage = "http://github.com/nvim-lua/plenary.nvim";
    description = "lua functions you don't want to write ";
    license.fullName = "MIT/X11";
  };
}) {};

rapidjson = callPackage({ lua, buildLuarocksPackage, luaOlder, fetchgit }:
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

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/xpol/lua-rapidjson";
    description = "Json module based on the very fast RapidJSON.";
    license.fullName = "MIT";
  };
}) {};

readline = callPackage({ buildLuarocksPackage, fetchurl, luaAtLeast, luaOlder, lua, luaposix }:
buildLuarocksPackage {
  pname = "readline";
  version = "3.2-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/readline-3.2-0.rockspec";
    sha256 = "1r0sgisxm4xd1r6i053iibxh30j7j3rcj4wwkd8rzkj8nln20z24";
  }).outPath;
  src = fetchurl {
    url    = "http://www.pjb.com.au/comp/lua/readline-3.2.tar.gz";
    sha256 = "1mk9algpsvyqwhnq7jlw4cgmfzj30l7n2r6ak4qxgdxgc39f48k4";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua luaposix ];

  meta = {
    homepage = "http://pjb.com.au/comp/lua/readline.html";
    description = "Interface to the readline library";
    license.fullName = "MIT/X11";
  };
}) {};

rest-nvim = callPackage({ lua, luaAtLeast, buildLuarocksPackage, luaOlder, fetchzip, plenary-nvim }:
buildLuarocksPackage {
  pname = "rest.nvim";
  version = "0.1-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rest.nvim-0.1-2.rockspec";
    sha256 = "0l8k91483nz75ijgnyfb8r7mynsaps7ikvjkziimf62bv7aks3qh";
  }).outPath;
  src = fetchzip {
    url    = "http://github.com/rest-nvim/rest.nvim/archive/0.1.zip";
    sha256 = "0yf1a1cjrrzw0wmjgg48g3qn9kfxn7hv38yx88l1sc1r1nsfijrq";
  };

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua plenary-nvim ];

  meta = {
    homepage = "https://github.com/rest-nvim/rest.nvim";
    description = "A fast Neovim http client written in Lua";
    maintainers = with lib.maintainers; [ teto ];
    license.fullName = "MIT";
  };
}) {};

say = callPackage({ luaOlder, fetchgit, lua, buildLuarocksPackage }:
buildLuarocksPackage {
  pname = "say";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/say.git",
  "rev": "45a3057e68c52b34ab59ef167efeb2340e356661",
  "date": "2022-08-27T11:00:01+03:00",
  "path": "/nix/store/324ryi5hlaisnyp4wpd1hvzcfv508i4s-say",
  "sha256": "178pdsswwnja2f106701xmdxsdijjl5smm28dhhdcmjyb4mn8cr2",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://lunarmodules.github.io/say";
    description = "Lua string hashing/indexing library";
    license.fullName = "MIT";
  };
}) {};

serpent = callPackage({ fetchgit, luaAtLeast, lua, buildLuarocksPackage, luaOlder }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/pkulchenko/serpent";
    description = "Lua serializer and pretty printer";
    maintainers = with lib.maintainers; [ lockejan ];
    license.fullName = "MIT";
  };
}) {};

sqlite = callPackage({ fetchgit, buildLuarocksPackage, luv }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  propagatedBuildInputs = [ luv ];

  meta = {
    homepage = "https://github.com/tami5/sqlite.lua";
    description = "SQLite/LuaJIT binding and a highly opinionated wrapper for storing, retrieving, caching, and persisting [SQLite] databases";
    license.fullName = "MIT";
  };
}) {};

std-_debug = callPackage({ buildLuarocksPackage, lua, luaOlder, fetchgit, luaAtLeast }:
buildLuarocksPackage {
  pname = "std._debug";
  version = "git-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lua-stdlib/_debug.git",
  "rev": "8b80b14bbbe7259a47c160176546bb152bb2d6f1",
  "date": "2023-01-31T16:39:35-07:00",
  "path": "/nix/store/i24iz2hvnjp18iz9z8kljsy9iv17m2zl-_debug",
  "sha256": "07z5lz3gy8wzzks79r3v68vckj42i3sybhfmqx7h2s58ld2kn5fd",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://lua-stdlib.github.io/_debug";
    description = "Debug Hints Library";
    license.fullName = "MIT/X11";
  };
}) {};

std-normalize = callPackage({ buildLuarocksPackage, fetchgit, lua, luaAtLeast, std-_debug, luaOlder }:
buildLuarocksPackage {
  pname = "std.normalize";
  version = "git-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lua-stdlib/normalize.git",
  "rev": "ccc697998af22d9d7f675e73f4b27c7a52151b5c",
  "date": "2022-01-02T16:33:35-08:00",
  "path": "/nix/store/nvyy1ibp43pzaldj6ark02ypqr45wmy1-normalize",
  "sha256": "1m6x4lp7xzghvagbqjljyqfcpilh76j25b71da6jd304xc9r0ngy",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua std-_debug ];

  meta = {
    homepage = "https://lua-stdlib.github.io/normalize";
    description = "Normalized Lua Functions";
    license.fullName = "MIT/X11";
  };
}) {};

stdlib = callPackage({ buildLuarocksPackage, luaAtLeast, fetchzip, lua, luaOlder }:
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

teal-language-server = callPackage({ luafilesystem, buildLuarocksPackage, dkjson, cyan, fetchgit }:
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
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  propagatedBuildInputs = [ cyan dkjson luafilesystem ];

  meta = {
    homepage = "https://github.com/teal-language/teal-language-server";
    description = "A language server for the Teal language";
    license.fullName = "MIT";
  };
}) {};

telescope-manix = callPackage({ telescope-nvim, buildLuarocksPackage, lua, fetchzip, luaOlder }:
buildLuarocksPackage {
  pname = "telescope-manix";
  version = "0.4.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/telescope-manix-0.4.0-1.rockspec";
    sha256 = "1kh3dn4aixydxrq01sbl40v7if8bmpsvv30qf7vig7dvl21aqkrp";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/mrcjkb/telescope-manix/archive/0.4.0.zip";
    sha256 = "153fqnk8iymyq309kpfiz3xmlqryj02rji3z7air23bgyjkx0gr8";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua telescope-nvim ];

  meta = {
    homepage = "https://github.com/mrcjkb/telescope-manix";
    description = "A telescope.nvim extension for Manix - A fast documentation searcher for Nix";
    license.fullName = "GPL-2.0";
  };
}) {};

telescope-nvim = callPackage({ plenary-nvim, buildLuarocksPackage, lua, fetchgit }:
buildLuarocksPackage {
  pname = "telescope.nvim";
  version = "scm-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/telescope.nvim-scm-1.rockspec";
    sha256 = "07mjkv1nv9b3ifxk2bbpbhvp0awblyklyz6aaqw418x4gm4q1g35";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/nvim-telescope/telescope.nvim",
  "rev": "a3f17d3baf70df58b9d3544ea30abe52a7a832c2",
  "date": "2023-02-26T13:26:12+01:00",
  "path": "/nix/store/qyzs7im9nqn04h9w9nii4nv12ysgk1fk-telescope.nvim",
  "sha256": "136pik53kwl2avjdakwfls10d85jqybl7yd0mbzxc5nry8krav22",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (lua.luaversion != "5.1");
  propagatedBuildInputs = [ lua plenary-nvim ];

  meta = {
    homepage = "https://github.com/nvim-telescope/telescope.nvim";
    description = "Find, Filter, Preview, Pick. All lua, all the time.";
    license.fullName = "MIT";
  };
}) {};

tl = callPackage({ compat53, luafilesystem, argparse, buildLuarocksPackage, fetchgit }:
buildLuarocksPackage {
  pname = "tl";
  version = "0.15.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/tl-0.15.1-1.rockspec";
    sha256 = "0f9wr91pxcvx43jp9ma4yb6f0r9yrc2fm437nx7xm0dyh7kac9p6";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/teal-language/tl",
  "rev": "a10fb2c69827c1b0f8e1b8a5c848a06d6da5d3be",
  "date": "2023-01-23T18:14:26-03:00",
  "path": "/nix/store/x5p9v443g53sz2c8rvxa465gzfiv47wb-tl",
  "sha256": "0hql1274wxji54cadalv4j3k82vd9xasvi119cdnm16mh85ir70s",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  propagatedBuildInputs = [ argparse compat53 luafilesystem ];

  meta = {
    homepage = "https://github.com/teal-language/tl";
    description = "Teal, a typed dialect of Lua";
    maintainers = with lib.maintainers; [ mephistophiles ];
    license.fullName = "MIT";
  };
}) {};

vstruct = callPackage({ fetchgit, lua, buildLuarocksPackage, luaOlder }:
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

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/ToxicFrog/vstruct";
    description = "Lua library to manipulate binary data";
  };
}) {};

vusted = callPackage({ buildLuarocksPackage, fetchgit, busted }:
buildLuarocksPackage {
  pname = "vusted";
  version = "2.2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/vusted-2.2.0-1.rockspec";
    sha256 = "1ri96pdwhck1sbdnkqj9ksv9hs86pv8v2f6vl25696v9snp9jkzs";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/notomo/vusted.git",
  "rev": "f142170d3b802f6cedfcff67b945a260087ecf65",
  "date": "2023-01-03T11:23:56+09:00",
  "path": "/nix/store/la7h2a39wnjkdg1fzhkgw3hbrhs4c5kf-vusted",
  "sha256": "17pdwaqjfkv2b7a801k5fdg2s0s75miiilfdjgmsyv7phighvkvw",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  propagatedBuildInputs = [ busted ];

  meta = {
    homepage = "https://github.com/notomo/vusted";
    description = "`busted` wrapper for testing neovim plugin";
    maintainers = with lib.maintainers; [ figsoda ];
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};


}
/* GENERATED - do not edit this file */
