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
  version = "0.4.1-1";
  rockspecDir = "dist";

  src = fetchTarball {
    url    = "https://github.com/aiq/basexx/archive/v0.4.1.tar.gz";
    sha256 = "1w1135ndjx0i09cp3n581h9j1kyqfcsd67ii8l1i96zh6hhm4ias";
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

  src = fetchTarball {
    url    = "https://github.com/Tieske/binaryheap.lua/archive/version_0v4.tar.gz";
    sha256 = "016gzrgnrgr2rch4y90yw2w4sfjv92j4fq44fa2pd5m0x3mbbz46";
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
, fetchgit, lua, mediator_lua, luafilesystem, dkjson, penlight, say, luasystem, luassert, lua-term, lua_cliargs
}:
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

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua mediator_lua luafilesystem dkjson penlight say luasystem luassert lua-term lua_cliargs ];

  meta = {
    homepage = "https://lunarmodules.github.io/busted/";
    description = "Elegant Lua unit testing";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

cassowary = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua, penlight
}:
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

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua penlight ];

  meta = {
    homepage = "https://github.com/sile-typesetter/cassowary.lua";
    description = "The cassowary constraint solver";
    maintainers = with lib.maintainers; [ marsam alerque ];
    license.fullName = "Apache 2";
  };
}) {};

cldr = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, penlight, lua
}:
buildLuarocksPackage {
  pname = "cldr";
  version = "0.2.0-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cldr-0.2.0-0.rockspec";
    sha256 = "1vjwrlrdy10bacn0324fvs4sx85xryyg7npw2mp1k9kmasfr8r1s";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/alerque/cldr-lua.git",
  "rev": "51e4760838c0a83ef1a76d0a0fb2e9f964069a50",
  "date": "2022-04-16T14:46:14+03:00",
  "path": "/nix/store/7jziz15bjm27zw9i3arrxprglakz8n4d-cldr-lua",
  "sha256": "1i22mcs50z99850j47gkgwyf0ahl4yh1732b4x3davjwy2fwak1x",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ penlight lua ];

  meta = {
    homepage = "https://github.com/alerque/cldr-lua";
    description = "Lua interface to Unicode CLDR data";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT/ICU";
  };
}) {};

compat53 = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "compat53";
  version = "0.7-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/compat53-0.7-1.rockspec";
    sha256 = "1r7a3q1cjrcmdycrv2ikgl83irjhxs53sa88v2fdpr9aaamlb101";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/keplerproject/lua-compat-5.3/archive/v0.7.zip";
    sha256 = "02a14nvn7aggg1yikj9h3dcf8aqjbxlws1bfvqbpfxv9d5phnrpz";
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

coxpcall = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit}:
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

cqueues = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "cqueues";
  version = "20200726.52-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cqueues-20200726.52-0.rockspec";
    sha256 = "0w2kq9w0wda56k02rjmvmzccz6bc3mn70s9v7npjadh85i5zlhhp";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/wahern/cqueues/archive/rel-20200726.tar.gz";
    sha256 = "17gwqndlga6gnishgs6wk8cvgwzanddr42yikkg2xd4nanhcg8z9";
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
, fetchgit, lpeg, lua
}:
buildLuarocksPackage {
  pname = "digestif";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/astoff/digestif",
  "rev": "95b13ba7ed33605406353b200920ece08868d5a8",
  "date": "2022-07-03T13:41:35+02:00",
  "path": "/nix/store/k8y6gk4pqri76657c2sy4j4bkyh30jz5-digestif",
  "sha256": "12pksz1l84iml7ng6yhywf0fyy8lclmcn2jjkdrh994lb7q9ya99",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.3");
  propagatedBuildInputs = [ lpeg lua ];

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
  version = "2.6-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/dkjson-2.6-1.rockspec";
    sha256 = "1hhmgz2nixqg23shfnl0kq6wxdadx36z6hhsrz33g7idbm6rbwm1";
  }).outPath;
  src = fetchTarball {
    url    = "http://dkolf.de/src/dkjson-lua.fsl/tarball/dkjson-2.6.tar.gz?uuid=release_2_6";
    sha256 = "1fpqb0vazbxwvdk0lvfppfh7gy7vz5jjsyp5ljlrvwngj05qqpsk";
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
    url    = "mirror://luarocks/fifo-0.2-0.rockspec";
    sha256 = "0vr9apmai2cyra2n573nr3dyk929gzcs4nm1096jdxcixmvh2ymq";
  }).outPath;
  src = fetchTarball {
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

fluent = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, cldr, lua, penlight, luaepnf
}:
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

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ cldr lua penlight luaepnf ];

  meta = {
    homepage = "https://github.com/alerque/fluent-lua";
    description = "Lua implementation of Project Fluent";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT";
  };
}) {};

gitsigns-nvim = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "gitsigns.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lewis6991/gitsigns.nvim",
  "rev": "1e107c91c0c5e3ae72c37df8ffdd50f87fb3ebfa",
  "date": "2022-08-22T10:33:16+01:00",
  "path": "/nix/store/k4kzl1d491vk60iabrbnj7ssvnki1brp-gitsigns.nvim",
  "sha256": "0qg2y796mkkisyab6br4p0d6blx8ispglpphpdlmf14hp9si56bp",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaversion != "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/lewis6991/gitsigns.nvim";
    description = "Git signs written in pure lua";
    license.fullName = "MIT/X11";
  };
}) {};

http = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, binaryheap, lua, luaossl, basexx, compat53, cqueues, fifo, lpeg, lpeg_patterns, bit32
}:
buildLuarocksPackage {
  pname = "http";
  version = "0.3-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/http-0.3-0.rockspec";
    sha256 = "0fn3irkf5nnmfc83alc40b316hs8l7zdq2xlaiaa65sjd8acfvia";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/daurnimator/lua-http/archive/v0.3.zip";
    sha256 = "1pqxxxifl2j1cik3kgayx43v6py5jp6r22myhvxfffysb3b84a2l";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ binaryheap lua luaossl basexx compat53 cqueues fifo lpeg lpeg_patterns bit32 ];

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
  version = "3.1.3-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/inspect-3.1.3-0.rockspec";
    sha256 = "1iivb2jmz0pacmac2msyqwvjjx8q6py4h959m8fkigia6srg5ins";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/kikito/inspect.lua/archive/v3.1.3.tar.gz";
    sha256 = "18c282fz4k1zfvpcpazl2n4ddj0yxjg7ccb63pgknll44yxaclab";
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

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
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
  "rev": "71dd5edbda829cd87b312956f4eae1ff8133fb14",
  "date": "2022-06-17T13:41:29+03:00",
  "path": "/nix/store/ywgvf4a5bdh7b7jzx8xgibch0a9kr9d2-LDoc",
  "sha256": "0wwr28fl46y84p78bxaw9wsb7b4x7hmjywfdx5d70axh0amnlyrv",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  propagatedBuildInputs = [ penlight markdown ];

  meta = {
    homepage = "https://github.com/lunarmodules/LDoc";
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

  src = fetchTarball {
    url    = "https://github.com/hoelzro/lua-linenoise/archive/0.9.tar.gz";
    sha256 = "02w1dr72rq9cl08i016f0nwmn8gd2gy31nmk3rmzmlysa5rp1l1y";
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
    url    = "mirror://luarocks/ljsyscall-0.12-1.rockspec";
    sha256 = "0zna5s852vn7q414z56kkyqwpighaghyq7h7in3myap4d9vcgm01";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/justincormack/ljsyscall/archive/v0.12.tar.gz";
    sha256 = "1wrcnjmgyc5q1njxffgf9q08zy4nrsmbdsmi4lppygb97w7jp37z";
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

lmathx = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "lmathx";
  version = "20150624-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lmathx-20150624-1.rockspec";
    sha256 = "181wzsj1mxjyia43y8zwaydxahnl7a70qzcgc8jhhgic7jyi9pgv";
  }).outPath;
  src = fetchTarball {
    url    = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.3/lmathx.tar.gz";
    sha256 = "0a1y6sk2biqryq67w7m7yhnsvz6gbkrlaf2sca954r50iyw2kdmf";
  };

  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#lmathx";
    description = "C99 extensions for the math library";
    maintainers = with lib.maintainers; [ alexshpilkin ];
    license.fullName = "Public domain";
  };
}) {};

lmpfrlib = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
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

  disabled = with lua; (luaOlder "5.3") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.circuitwizard.de/lmpfrlib/lmpfrlib.html";
    description = "Lua API for the GNU MPFR library";
    maintainers = with lib.maintainers; [ alexshpilkin ];
    license.fullName = "LGPL";
  };
}) {};

loadkit = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
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

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/leafo/loadkit";
    description = "Loadkit allows you to load arbitrary files within the Lua package path";
    maintainers = with lib.maintainers; [ alerque ];
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
    url    = "mirror://luarocks/lpeg-1.0.2-1.rockspec";
    sha256 = "08a8p5cwlwpjawk8sczb7bq2whdsng4mmhphahyklf1bkvl2li89";
  }).outPath;
  src = fetchTarball {
    url    = "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.2.tar.gz";
    sha256 = "1plyzw9aj6gzkc0a9x7x1z440frsna21x0rwz8wgx0i8434291gj";
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
, fetchurl, lpeg, lua
}:
buildLuarocksPackage {
  pname = "lpeg_patterns";
  version = "0.5-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lpeg_patterns-0.5-0.rockspec";
    sha256 = "1vzl3ryryc624mchclzsfl3hsrprb9q214zbi1xsjcc4ckq5qfh7";
  }).outPath;
  src = fetchTarball {
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

lpeglabel = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "lpeglabel";
  version = "1.6.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lpeglabel-1.6.0-1.rockspec";
    sha256 = "13gc32pggng6f95xx5zw9n9ian518wlgb26mna9kh4q2xa1k42pm";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/sqmedeiros/lpeglabel/archive/v1.6.0-1.tar.gz";
    sha256 = "0fsnxsh6zyqdmjd89bffj98mpcrk79znbd9niv5ax96zfcqypkvq";
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
    url    = "mirror://luarocks/lpty-1.2.2-1.rockspec";
    sha256 = "04af4mhiqrw3br4qzz7yznw9zy2m50wddwzgvzkvhd99ng71fkzg";
  }).outPath;
  src = fetchTarball {
    url    = "http://www.tset.de/downloads/lpty-1.2.2-1.tar.gz";
    sha256 = "1zbrmls9al60b32p8g2xhkf4d4fhfffsq4p1rjffvpg3rks3189m";
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
    url    = "mirror://luarocks/lua-cjson-2.1.0.6-1.rockspec";
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
    url    = "mirror://luarocks/lua-iconv-7-3.rockspec";
    sha256 = "0qh5vsaxd7s31p7a8rl08lwd6zv90wnvp15nll4fcz452kffpp72";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/downloads/ittner/lua-iconv/lua-iconv-7.tar.gz";
    sha256 = "1c1m1bviws9rbi38yqgfllqp8xl57mnyh4p28ww08giz249q1gwp";
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
, fetchgit, inspect, lua, dkjson, lpeglabel
}:
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

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ inspect lua dkjson lpeglabel ];

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
    url    = "mirror://luarocks/lua-messagepack-0.5.2-1.rockspec";
    sha256 = "15liz6v8hsqgb3xrcd74a71nnjcz79gpc3ak351hk6k4gyjq2rfc";
  }).outPath;
  src = fetchTarball {
    url    = "https://framagit.org/fperrad/lua-MessagePack/raw/releases/lua-messagepack-0.5.2.tar.gz";
    sha256 = "09bprg7016lblyv7sr1hlvcldvxbys2fdyp6ymabmz5a25kvh4lm";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://fperrad.frama.io/lua-MessagePack/";
    description = "a pure Lua implementation of the MessagePack serialization format";
    license.fullName = "MIT/X11";
  };
}) {};

lua-protobuf = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "lua-protobuf";
  version = "0.4.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-protobuf-0.4.0-1.rockspec";
    sha256 = "053r6z37847wm1xaxv5rwplmdqkp507qawgd382z0l7m05f06ls9";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/starwing/lua-protobuf.git",
  "rev": "832facd266366cd86ee9bf41d35327255d0033f2",
  "date": "2022-07-27T14:34:12+08:00",
  "path": "/nix/store/g68x4cbi6ssd5zak14r5cbi7k88d3ml9-lua-protobuf",
  "sha256": "0ynfq0va4w8zlr67ld6v9nmi5mnvchfygd8h5jbwk2vzlj9hg2yw",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/starwing/lua-protobuf";
    description = "protobuf data support for Lua";
    maintainers = with lib.maintainers; [ lockejan ];
    license.fullName = "MIT";
  };
}) {};

lua-resty-http = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
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

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/ledgetech/lua-resty-http";
    description = "Lua HTTP client cosocket driver for OpenResty / ngx_lua.";
    license.fullName = "2-clause BSD";
  };
}) {};

lua-resty-jwt = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua-resty-openssl, lua
}:
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

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua-resty-openssl lua ];

  meta = {
    homepage = "https://github.com/cdbattags/lua-resty-jwt";
    description = "JWT for ngx_lua and LuaJIT.";
    license.fullName = "Apache License Version 2";
  };
}) {};

lua-resty-openidc = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua-resty-http, lua, lua-resty-session, lua-resty-jwt
}:
buildLuarocksPackage {
  pname = "lua-resty-openidc";
  version = "1.7.5-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-openidc-1.7.5-1.rockspec";
    sha256 = "14z69c0v35hmhlqvg7kndagpqxa4j7i3cgkm0iyfradqlvgamab4";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/zmartzone/lua-resty-openidc",
  "rev": "85e30a13e08156ef3d782ecf7236758334234c6c",
  "date": "2021-12-21T16:23:45+01:00",
  "path": "/nix/store/yr827kcbbrvxpymny5sa43sb1wf0vzqj-lua-resty-openidc",
  "sha256": "111mnnl639mnyig105zp5bfynjsdnvs201wpg68zd218bh5f362l",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua-resty-http lua lua-resty-session lua-resty-jwt ];

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
  version = "0.8.10-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-openssl-0.8.10-1.rockspec";
    sha256 = "0rwqc8yy9jk419vyil3c1dc2cmlsy1yf2f8b85i1xvwd8safvc8g";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/fffonion/lua-resty-openssl.git",
  "rev": "c569d6c2ed4512f2228b61a52c9bb1949dc55f7c",
  "date": "2022-06-24T12:22:19+08:00",
  "path": "/nix/store/kbpwc7yhba4gqp6lkmdphkvkvhc1m4h6-lua-resty-openssl",
  "sha256": "08cw03kihqa2j23p29dxli84zafpdxnx5a4zm625dqzlqnq86ajc",
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
  version = "3.10-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-session-3.10-1.rockspec";
    sha256 = "1a939ndnyqdn633dxv9nsfkgj59ig71822syx9qk0ai3v6426mw3";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/bungle/lua-resty-session.git",
  "rev": "e6bf2630c90df7b3db35e859f0aa7e096af3e918",
  "date": "2022-01-14T20:16:34+02:00",
  "path": "/nix/store/76fxliqmhghj6r5qg5q2r59n6nzapra5-lua-resty-session",
  "sha256": "1lx0pbb5swyl0fhxycqx0fs3r158rczb78fav02wlz43yc3nbfax",
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
    url    = "mirror://luarocks/lua-term-0.7-1.rockspec";
    sha256 = "0r9g5jw7pqr1dyj6w58dqlr7y7l0jp077n8nnji4phf10biyrvg2";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/hoelzro/lua-term/archive/0.07.tar.gz";
    sha256 = "19ggydrcaiz3my8r8lyz9171cnmqms1w42121k2pdp3c3b8zaxi8";
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

  disabled = with lua; (luaOlder "5.1");
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

  src = fetchTarball {
    url    = "https://github.com/amireh/lua_cliargs/archive/v3.0-2.tar.gz";
    sha256 = "18jq3kxn2nm2rgxvgkkvg9gm22bbrrwf4vzp6jzyn1w087742xb1";
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
, fetchgit, argparse, lua, luafilesystem
}:
buildLuarocksPackage {
  pname = "luacheck";
  version = "1.0.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luacheck-1.0.0-1.rockspec";
    sha256 = "0q5kqix5n016piqhasp4h22srz1lzp96cjls4fgsbirjn87gsnxv";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/luacheck.git",
  "rev": "4d2979930245415e556a7c9f47b63ea038afcfee",
  "date": "2022-08-24T12:50:43+03:00",
  "path": "/nix/store/kfqdn4v9nzqqdw02fri10ic7v61r99n7-luacheck",
  "sha256": "1dkqcaf0yrbcwbjiqbpdksj39sj8rbkd8432q568dgq2z5y9khcf",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ argparse lua luafilesystem ];

  meta = {
    homepage = "https://github.com/lunarmodules/luacheck";
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

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-mysql = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, luadbi, lua
}:
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

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ luadbi lua ];

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

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luaepnf = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lpeg, lua
}:
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

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lpeg lua ];

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
    url    = "mirror://luarocks/luaevent-0.4.6-1.rockspec";
    sha256 = "03zixadhx4a7nh67n0sm6sy97c8i9va1a78hibhrl7cfbqc2zc7f";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/harningt/luaevent/archive/v0.4.6.tar.gz";
    sha256 = "0x1f2y276x8zbjp8dcjxxhl5mlmxfdcrbwvp05pv85913vah2qvs";
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
, fetchgit, lua
}:
buildLuarocksPackage {
  pname = "luaexpat";
  version = "1.4.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaexpat-1.4.1-1.rockspec";
    sha256 = "1abwd385x7wnza7qqz5s4aj6m2l1c23pjmbgnpq73q0s17pn1h0c";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/luaexpat.git",
  "rev": "79edb1deaa0987a5abb33360b0d46b1fe641b59c",
  "date": "2022-07-18T11:09:09+02:00",
  "path": "/nix/store/ksphqx3b01c31nshidmi2bhcyf7hrg2h-luaexpat",
  "sha256": "1pjayf2dn0xrx6xcjmhdinz70q4d3aq3m638gz1wi717c3rnmx3f",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://lunarmodules.github.io/luaexpat";
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
    url    = "mirror://luarocks/luafilesystem-1.7.0-2.rockspec";
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
  version = "1.6.0-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lualogging-1.6.0-2.rockspec";
    sha256 = "1235sfss0gmcw744rnhzfffhd1z732g2b2vsbpbz9kcvvhznmamb";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/lualogging.git",
  "rev": "0bc4415de03ff1a99c92c02a5bed14a45b078079",
  "date": "2021-11-09T20:20:42+01:00",
  "path": "/nix/store/p3cyhqjw12bj7s6y4hndzqdkdfwq3958-lualogging",
  "sha256": "18664k4kfi4zq9n0217j57h42li6ws8s3f6d4yj0rcqsl19fxa7c",
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
  version = "20220711-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaossl-20220711-0.rockspec";
    sha256 = "0b68kvfz587ilmb5c1p7920kysg9q4m4fl4cz4d93jl3270mzh8y";
  }).outPath;
  src = fetchTarball {
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

luaposix = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua, bit32
}:
buildLuarocksPackage {
  pname = "luaposix";
  version = "34.1.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaposix-34.1.1-1.rockspec";
    sha256 = "0hx6my54axjcb3bklr991wji374qq6mwa3ily6dvb72vi2534nwz";
  }).outPath;
  src = fetchTarball {
    url    = "http://github.com/luaposix/luaposix/archive/v34.1.1.zip";
    sha256 = "0863r8c69yx92lalj174qdhavqmcs2cdimjim6k55qj9yn78v9zl";
  };

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua bit32 ];

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
  version = "0.10-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luarepl-0.10-1.rockspec";
    sha256 = "12zdljfs4wg55mj7a38iwg7p5i1pmc934v9qlpi61sw4brp6x8d3";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/hoelzro/lua-repl/archive/0.10.tar.gz";
    sha256 = "1in41fd31nxr8idmqap2wgkfkrvhi3i28rmb0215hd2x64q6j0fk";
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
, fetchgit, luasocket, lua
}:
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

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ luasocket lua ];

  meta = {
    homepage = "https://github.com/brunoos/luasec/wiki";
    description = "A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket.";
    maintainers = with lib.maintainers; [ flosse ];
    license.fullName = "MIT";
  };
}) {};

luasocket = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
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

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/lunarmodules/luasocket";
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
    url    = "mirror://luarocks/luasql-sqlite3-2.6.0-1.rockspec";
    sha256 = "0w32znsfcaklcja6avqx7daaxbf0hr2v8g8bmz0fysb3401lmp02";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/luasql.git",
  "rev": "b7da7097d91b3233156aba2e7d0c6e5590766884",
  "date": "2022-07-27T13:39:06-03:00",
  "path": "/nix/store/rb4i0qxm8yy552hhmxdh65sf463qn02f-luasql",
  "sha256": "046zv23kk2riyiw1vngbwn2a4rkg9wm3ra2b1vmmhkr9idlncq94",
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
, fetchgit, say, lua
}:
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

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ say lua ];

  meta = {
    homepage = "https://lunarmodules.github.io/busted/";
    description = "Lua assertions extension";
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
    url    = "mirror://luarocks/luasystem-0.2.1-0.rockspec";
    sha256 = "0xj5q7lzsbmlw5d3zbjqf3jpj78wcn348h2jcxn5ph4n4hx73z3n";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/o-lim/luasystem/archive/v0.2.1.tar.gz";
    sha256 = "0g0wc529f0w13mzd8q5122rbc40iasp24b8ka7hpj2srfb4scaq3";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://olivinelabs.com/luasystem/";
    description = "Platform independent system calls for Lua.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

luaunbound = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luaunbound";
  version = "1.0.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaunbound-1.0.0-1.rockspec";
    sha256 = "1zlkibdwrj5p97nhs33cz8xx0323z3kiq5x7v0h3i7v6j0h8ppvn";
  }).outPath;
  src = fetchTarball {
    url    = "https://code.zash.se/dl/luaunbound/luaunbound-1.0.0.tar.gz";
    sha256 = "1i1a8653hgknbf3qg3avzqcxyfzqd0dms4ls1q79lfkd8qavdbfl";
  };

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://www.zash.se/luaunbound.html";
    description = "A binding to libunbound";
    license.fullName = "MIT";
  };
}) {};

luaunit = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luaunit";
  version = "3.4-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaunit-3.4-1.rockspec";
    sha256 = "111435fa8p2819vcvg76qmknj0wqk01gy9d1nh55c36616xnj54n";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/bluebird75/luaunit/releases/download/LUAUNIT_V3_4/rock-luaunit-3.4.zip";
    sha256 = "0qf07y3229lq3qq1mfkv83gzbc7dgyr67hysqjb5bbk333flv56r";
  };

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/bluebird75/luaunit";
    description = "A unit testing framework for Lua";
    maintainers = with lib.maintainers; [ lockejan ];
    license.fullName = "BSD";
  };
}) {};

luautf8 = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luautf8";
  version = "0.1.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luautf8-0.1.3-1.rockspec";
    sha256 = "16i9wfgd0f299g1afgjp0hhczlrk5g8i0kq3ka0f8bwj3mp2wmcp";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/starwing/luautf8/archive/0.1.3.tar.gz";
    sha256 = "19hs8rml4klj05c3g5hf3fnskk2jlcamlx2n014yxdyz6qngv6pn";
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
    url    = "mirror://luarocks/luuid-20120509-2.rockspec";
    sha256 = "1q2fv25wfbiqn49mqv26gs4pyllch311akcf7jjn27l5ik8ji5b6";
  }).outPath;
  src = fetchTarball {
    url    = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.2/luuid.tar.gz";
    sha256 = "1fzlvzbmldpdmsxkvb06fbcx1a57i3b9xj7z8mzjjyzlkaas2lyc";
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
, cmake, fetchurl, lua
}:
buildLuarocksPackage {
  pname = "luv";
  version = "1.43.0-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luv-1.43.0-0.rockspec";
    sha256 = "0z5a7yp20xbb3f9w73skm9fj89gxxqv72nrxjq3kycsc6c2v3m8f";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/luvit/luv/releases/download/1.43.0-0/luv-1.43.0-0.tar.gz";
    sha256 = "05nfxlp8xad940cdqbgqiakqfda80lijk81iy9sb3a7hd4lajka2";
  };

  disabled = with lua; (luaOlder "5.1");
  nativeBuildInputs = [ cmake ];
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
    url    = "mirror://luarocks/lyaml-6.2.7-1.rockspec";
    sha256 = "0m5bnzg24nyk35gcn4rydgzk0ysk1f6rslxwxd0w3drl1bg64zja";
  }).outPath;
  src = fetchTarball {
    url    = "http://github.com/gvvaughan/lyaml/archive/v6.2.7.zip";
    sha256 = "1qfvk610xgglyv9n2dp0cnh21f20q2zkl941qsv9qcbnm2f03vna";
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
    url    = "mirror://luarocks/mediator_lua-1.1.2-0.rockspec";
    sha256 = "0frzvf7i256260a1s8xh92crwa2m42972qxfq29zl05aw3pyn7bm";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/Olivine-Labs/mediator_lua/archive/v1.1.2-0.tar.gz";
    sha256 = "1vsm1ad55f7wfmhdag0srrw2achmkkfsy4gbqwp6s6shcira06ks";
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
, fetchgit, lpeg, lua, argparse, luafilesystem
}:
buildLuarocksPackage {
  pname = "moonscript";
  version = "dev-1";

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
  propagatedBuildInputs = [ lpeg lua argparse luafilesystem ];

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
    url    = "mirror://luarocks/mpack-1.0.9-0.rockspec";
    sha256 = "1v10kmw3qw559bbm142z40ib26bwvcyi64qjrk0vf8v6n1mx8wcn";
  }).outPath;
  src = fetchTarball {
    url    = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.9/libmpack-lua-1.0.9.tar.gz";
    sha256 = "07vahzxcigl6pm9xrmxnxqb3374vh1wfsag9is1wiffla0ka0w3h";
  };


  meta = {
    homepage = "https://github.com/libmpack/libmpack-lua";
    description = "Lua binding to libmpack";
    license.fullName = "MIT";
  };
}) {};

nvim-client = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, lua, mpack, coxpcall, luv
}:
buildLuarocksPackage {
  pname = "nvim-client";
  version = "0.2.4-1";

  src = fetchTarball {
    url    = "https://github.com/neovim/lua-client/archive/0.2.4-1.tar.gz";
    sha256 = "0hb35b5w78bm2clwvf5wwy86jlkp8zyvgipcl40d75p0qlv3x7p8";
  };

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua mpack coxpcall luv ];

  meta = {
    homepage = "https://github.com/neovim/lua-client";
    description = "Lua client to Nvim";
    license.fullName = "Apache";
  };
}) {};

penlight = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, luafilesystem, lua
, busted
}:
buildLuarocksPackage {
  pname = "penlight";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/penlight.git",
  "rev": "d5958e242b95984a278c39c63fadc5ef1258978b",
  "date": "2022-08-14T10:06:20+02:00",
  "path": "/nix/store/91nha43c2gdjyn8146fn9zfghlgvvdzz-penlight",
  "sha256": "0bvc1a3g41mx8wlaq4ig3cl568rsysyggsr00hf7bi0ygf529sny",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ luafilesystem lua ];
  checkInputs = [ busted ];

  meta = {
    homepage = "https://lunarmodules.github.io/penlight";
    description = "Lua utility libraries loosely based on the Python standard libraries";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT/X11";
  };
}) {};

plenary-nvim = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, luassert, lua
}:
buildLuarocksPackage {
  pname = "plenary.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/nvim-lua/plenary.nvim",
  "rev": "31807eef4ed574854b8a53ae40ea3292033a78ea",
  "date": "2022-08-01T17:54:48+02:00",
  "path": "/nix/store/m4h2mdxybapj0k12zdmmzlkhra82bz2k-plenary.nvim",
  "sha256": "1vkyqrk0shpc076rq1s7rwldmcmw2k96hcpifligrsplr170kkhv",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ luassert lua ];

  meta = {
    homepage = "http://github.com/nvim-lua/plenary.nvim";
    description = "lua functions you don't want to write ";
    license.fullName = "MIT/X11";
  };
}) {};

rapidjson = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, cmake, fetchgit, lua
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
  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/xpol/lua-rapidjson";
    description = "Json module based on the very fast RapidJSON.";
    license.fullName = "MIT";
  };
}) {};

readline = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchurl, luaposix, lua
}:
buildLuarocksPackage {
  pname = "readline";
  version = "3.1-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/readline-3.1-0.rockspec";
    sha256 = "0bl5hsplnlg8fx3v83sz48y2p1rlxfig3iycnk1pn3xi724kscnc";
  }).outPath;
  src = fetchTarball {
    url    = "http://www.pjb.com.au/comp/lua/readline-3.1.tar.gz";
    sha256 = "07b4h9b7mxwqlkvwfpkiv76kmixzaxhm1w819z7gpm0b01dqb8fy";
  };

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ luaposix lua ];

  meta = {
    homepage = "http://pjb.com.au/comp/lua/readline.html";
    description = "Interface to the readline library";
    license.fullName = "MIT/X11";
  };
}) {};

say = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
, busted
}:
buildLuarocksPackage {
  pname = "say";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/say.git",
  "rev": "7feb0219795896a5631e777645eeb8ae29f37663",
  "date": "2022-08-23T22:06:56+03:00",
  "path": "/nix/store/3cnzc9ilp8jwl9vbdyb0kqz0l63j2s32-say",
  "sha256": "05hcw9c4l1pkx0ia3cdwlqxzwm82am28xxb6c3bgv24hsm2dg8az",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = with lua; (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];
  checkInputs = [ busted ];

  meta = {
    homepage = "https://lunarmodules.github.io/busted/";
    description = "Lua string hashing/indexing library";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

serpent = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, lua
}:
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

  disabled = with lua; (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/pkulchenko/serpent";
    description = "Lua serializer and pretty printer";
    maintainers = with lib.maintainers; [ lockejan ];
    license.fullName = "MIT";
  };
}) {};

sqlite = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, luv
, plenary-nvim
}:
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
  checkInputs = [ plenary-nvim ];

  meta = {
    homepage = "https://github.com/tami5/sqlite.lua";
    description = "SQLite/LuaJIT binding and a highly opinionated wrapper for storing, retrieving, caching, and persisting [SQLite] databases";
    license.fullName = "MIT";
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
  "rev": "6ab5e78ef21ad9877e9733a178df4799b983e178",
  "date": "2022-06-29T11:27:54-07:00",
  "path": "/nix/store/c3p5jq6bawdmfnq1ayw6d7kwwc9sqmig-_debug",
  "sha256": "1q0gvwwjclf4galz9c9h2xbzh799xswr9z9b7lncmwb5ky2jwpcy",
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
    url    = "mirror://luarocks/stdlib-41.2.2-1.rockspec";
    sha256 = "0rscb4cm8s8bb8fk8rknc269y7bjqpslspsaxgs91i8bvabja6f6";
  }).outPath;
  src = fetchTarball {
    url    = "http://github.com/lua-stdlib/lua-stdlib/archive/release-v41.2.2.zip";
    sha256 = "0ry6k0wh4vyar1z68s0qmqzkdkfn9lcznsl8av7x78qz6l16wfw4";
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

tl = callPackage({ buildLuarocksPackage, luaOlder, luaAtLeast
, fetchgit, argparse, compat53, luafilesystem
, dkjson
}:
buildLuarocksPackage {
  pname = "tl";
  version = "0.14.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/tl-0.14.1-1.rockspec";
    sha256 = "09nm8vgn1j33bj6612h48jqv7vd72qm06f6rly0angkpcdzb2cd7";
  }).outPath;
  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/teal-language/tl",
  "rev": "2a0426ed42a3616981410bab0ef1faa55ab9795d",
  "date": "2022-08-23T02:17:01-03:00",
  "path": "/nix/store/50p7nazikq1n1nffl84lnh8l39nm18pq-tl",
  "sha256": "04bbls8dc0jg7vbqwafn24gqna4swk3aa760i98hnrbmax39pzh2",
  "fetchLFS": false,
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  propagatedBuildInputs = [ argparse compat53 luafilesystem ];
  checkInputs = [ dkjson ];

  meta = {
    homepage = "https://github.com/teal-language/tl";
    description = "Teal, a typed dialect of Lua";
    maintainers = with lib.maintainers; [ mephistophiles ];
    license.fullName = "MIT";
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
