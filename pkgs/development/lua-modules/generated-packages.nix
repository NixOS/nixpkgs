/* pkgs/development/lua-modules/generated-packages.nix is an auto-generated file -- DO NOT EDIT!
Regenerate it with: nix run nixpkgs#luarocks-packages-updater
You can customize the generated packages in pkgs/development/lua-modules/overrides.nix
*/

{ stdenv, lib, fetchurl, fetchgit, callPackage, ... }:
final: prev:
{
alt-getopt = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "alt-getopt";
  version = "0.8.0-1";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/alt-getopt-0.8.0-1.rockspec";
    sha256 = "17yxi1lsrbkmwzcn1x48x8758d7v1frsz1bmnpqfv4vfnlh0x210";
  }).outPath;
  src = fetchFromGitHub {
    owner = "cheusov";
    repo = "lua-alt-getopt";
    rev = "0.8.0";
    hash = "sha256-OxtMNB8++cVQ/gQjntLUt3WYopGhYb1VbIUAZEzJB88=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.4";

  meta = {
    homepage = "https://github.com/cheusov/lua-alt-getopt";
    description = "Process application arguments the same way as getopt_long";
    maintainers = with lib.maintainers; [ arobyn ];
    license.fullName = "MIT/X11";
  };
}) {};

argparse = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "argparse";
  version = "0.7.1-1";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/argparse-0.7.1-1.rockspec";
    sha256 = "116iaczq6glzzin6qqa2zn7i22hdyzzsq6mzjiqnz6x1qmi0hig8";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/luarocks/argparse/archive/0.7.1.zip";
    sha256 = "0idg79d0dfis4qhbkbjlmddq87np75hb2vj41i6prjpvqacvg5v1";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "https://github.com/luarocks/argparse";
    description = "A feature-rich command-line argument parser";
    license.fullName = "MIT";
  };
}) {};

basexx = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/aiq/basexx";
    description = "A base2, base16, base32, base64 and base85 library for Lua";
    license.fullName = "MIT";
  };
}) {};

binaryheap = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/Tieske/binaryheap.lua";
    description = "Binary heap implementation in pure Lua";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT/X11";
  };
}) {};

bit32 = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "bit32";
  version = "5.3.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/bit32-5.3.0-1.rockspec";
    sha256 = "1d6xdihpksrj5a3yvsvnmf3vfk15hj6f8n1rrs65m7adh87hc0yd";
  }).outPath;
  src = fetchFromGitHub {
    owner = "keplerproject";
    repo = "lua-compat-5.2";
    rev = "bitlib-5.3.0";
    hash = "sha256-Ek7FMWskfHwHhEVfjTDZyL/cruHDiQo5Jmnwsvai+MY=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "http://www.lua.org/manual/5.2/manual.html#6.7";
    description = "Lua 5.2 bit manipulation library";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT/X11";
  };
}) {};

busted = callPackage({ buildLuarocksPackage, dkjson, fetchFromGitHub, fetchurl, lua-term, luaOlder, lua_cliargs, luassert, luasystem, mediator_lua, penlight, say }:
buildLuarocksPackage {
  pname = "busted";
  version = "2.2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/busted-2.2.0-1.rockspec";
    sha256 = "0h4zk4lcm40wg3l0vgjn6lsyh9yayhljx65a0pz5n99dxal8lgnf";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "busted";
    rev = "v2.2.0";
    hash = "sha256-5LxPqmoUwR3XaIToKUgap0L/sNS9uOV080MIenyLnl8=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ dkjson lua-term lua_cliargs luassert luasystem mediator_lua penlight say ];

  meta = {
    homepage = "https://lunarmodules.github.io/busted/";
    description = "Elegant Lua unit testing";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

cassowary = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder, penlight }:
buildLuarocksPackage {
  pname = "cassowary";
  version = "2.3.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cassowary-2.3.2-1.rockspec";
    sha256 = "0c6sflm8zpgbcdj47s3rd34h69h3nqcciaaqd1wdx5m0lwc3mii0";
  }).outPath;
  src = fetchFromGitHub {
    owner = "sile-typesetter";
    repo = "cassowary.lua";
    rev = "v2.3.2";
    hash = "sha256-wIVuf1L3g2BCM+zW4Nt1IyU6xaP4yYuzxHjVDxsgdNM=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ penlight ];

  meta = {
    homepage = "https://github.com/sile-typesetter/cassowary.lua";
    description = "The cassowary constraint solver";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "Apache 2";
  };
}) {};

cldr = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder, penlight }:
buildLuarocksPackage {
  pname = "cldr";
  version = "0.3.0-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cldr-0.3.0-0.rockspec";
    sha256 = "1fnr8k713w21v7hc64s4w5lgcgnbphq3gm69pisc2s4wq2fkija1";
  }).outPath;
  src = fetchFromGitHub {
    owner = "alerque";
    repo = "cldr-lua";
    rev = "v0.3.0";
    hash = "sha256-5LY0YxHACtreP38biDZD97bkPuuT7an/Z1VBXEJYjkI=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ penlight ];

  meta = {
    homepage = "https://github.com/alerque/cldr-lua";
    description = "Lua interface to Unicode CLDR data";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT/ICU";
  };
}) {};

commons-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
buildLuarocksPackage {
  pname = "commons.nvim";
  version = "15.0.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/commons.nvim-15.0.2-1.rockspec";
    sha256 = "1n78bgp9y2smnhkjkdvn2c6lq6071k9dml4j6r7hk462hxsbjsqn";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/linrongbin16/commons.nvim/archive/cc17fd28c5f171c5d55f75d668b812e2d70b4cf3.zip";
    sha256 = "0w5z03r59jy3zb653dwp9c6fq8ivjj1j2ksnsx95wlmj1mx04ixi";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://linrongbin16.github.io/commons.nvim/";
    description = "The commons lua library for Neovim plugin project.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

compat53 = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "compat53";
  version = "0.13-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/compat53-0.13-1.rockspec";
    sha256 = "10gmhd526a5q0dl4dvjq7a5c7f3i7hcdla8hpygl79dhgbm649i3";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/lunarmodules/lua-compat-5.3/archive/v0.13.zip";
    sha256 = "06kpx5qyk1zki2r2g6z3alwhvmays50670z7mbl55h7s0kff2cpz";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "https://github.com/lunarmodules/lua-compat-5.3";
    description = "Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT";
  };
}) {};

cosmo = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, lpeg }:
buildLuarocksPackage {
  pname = "cosmo";
  version = "16.06.04-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cosmo-16.06.04-1.rockspec";
    sha256 = "0ipv1hrlhvaz1myz6qxabq7b7kb3bz456cya3r292487a3g9h9pb";
  }).outPath;
  src = fetchFromGitHub {
    owner = "mascarenhas";
    repo = "cosmo";
    rev = "v16.06.04";
    hash = "sha256-mJE5GkDnfZ3qAQyyyKj+aXOtlITeYs8lerGJSTzU/Tk=";
  };

  propagatedBuildInputs = [ lpeg ];

  meta = {
    homepage = "http://cosmo.luaforge.net";
    description = "Safe templates for Lua";
    license.fullName = "MIT/X11";
  };
}) {};

coxpcall = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl }:
buildLuarocksPackage {
  pname = "coxpcall";
  version = "1.17.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/coxpcall-1.17.0-1.rockspec";
    sha256 = "0mf0nggg4ajahy5y1q5zh2zx9rmgzw06572bxx6k8b736b8j7gca";
  }).outPath;
  src = fetchFromGitHub {
    owner = "keplerproject";
    repo = "coxpcall";
    rev = "v1_17_0";
    hash = "sha256-EW8pGI9jiGutNVNmyiCP5sIVYZe2rJQc03OrKXIOeMw=";
  };


  meta = {
    homepage = "http://keplerproject.github.io/coxpcall";
    description = "Coroutine safe xpcall and pcall";
    license.fullName = "MIT/X11";
  };
}) {};

cqueues = callPackage({ buildLuarocksPackage, fetchurl, lua }:
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

  disabled = lua.luaversion != "5.2";

  meta = {
    homepage = "http://25thandclement.com/~william/projects/cqueues.html";
    description = "Continuation Queues: Embeddable asynchronous networking, threading, and notification framework for Lua on Unix.";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT/X11";
  };
}) {};

cyan = callPackage({ argparse, buildLuarocksPackage, fetchFromGitHub, fetchurl, luafilesystem, tl }:
buildLuarocksPackage {
  pname = "cyan";
  version = "0.3.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/cyan-0.3.0-1.rockspec";
    sha256 = "1bs5gwgdhibj2gm8y3810b0hh6s9n00fgij8nnjag9kpqrd80vsj";
  }).outPath;
  src = fetchFromGitHub {
    owner = "teal-language";
    repo = "cyan";
    rev = "51649e4a814c05deaf5dde929ba82803f5170bbc";
    hash = "sha256-83F2hFAXHLg4l5O0+j3zbwTv0TaCWEfWErO9C0V9W04=";
  };

  propagatedBuildInputs = [ argparse luafilesystem tl ];

  meta = {
    homepage = "https://github.com/teal-language/cyan";
    description = "A build system for the Teal language";
    license.fullName = "MIT";
  };
}) {};

digestif = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, lpeg, luaOlder }:
buildLuarocksPackage {
  pname = "digestif";
  version = "0.5.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/digestif-0.5.1-1.rockspec";
    sha256 = "03hhzpq1szdw43slq38wbndwh8knv71q9pgwd7hvvkp9wykzjhwr";
  }).outPath;
  src = fetchFromGitHub {
    owner = "astoff";
    repo = "digestif";
    rev = "v0.5.1";
    hash = "sha256-8QTc4IKD1tjRlyrSZy7cyUzRkvm6IHwlOXchPf2BaMk=";
  };

  disabled = luaOlder "5.3";
  propagatedBuildInputs = [ lpeg ];

  meta = {
    homepage = "https://github.com/astoff/digestif/";
    description = "A code analyzer for TeX";
    license.fullName = "GPLv3+ and other free licenses";
  };
}) {};

dkjson = callPackage({ buildLuarocksPackage, fetchurl, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "dkjson";
  version = "2.7-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/dkjson-2.7-1.rockspec";
    sha256 = "0kgrgyn848hadsfhf2wccamgdpjs1cz7424fjp9vfqzjbwa06lxd";
  }).outPath;
  src = fetchurl {
    url    = "http://dkolf.de/dkjson-lua/dkjson-2.7.tar.gz";
    sha256 = "sha256-TFGmIQLy9r23Z3fx23NgUJtKARaANYi06CVfQ1ryOVw=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "http://dkolf.de/dkjson-lua/";
    description = "David Kolf's JSON module for Lua";
    license.fullName = "MIT/X11";
  };
}) {};

fennel = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "fennel";
  version = "1.4.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/fennel-1.4.2-1.rockspec";
    sha256 = "17ygacyqdvplyz3046ay3xr4z83sdjrxkcl21mklpxx29j8p0bv1";
  }).outPath;
  src = fetchurl {
    url    = "https://fennel-lang.org/downloads/fennel-1.4.2.tar.gz";
    sha256 = "1inhy8rrywx8svdzhy1yaaa0cfyrmi21ckj7h8xmd7yqaw66ma86";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://fennel-lang.org/";
    description = "A lisp that compiles to Lua";
    maintainers = with lib.maintainers; [ misterio77 ];
    license.fullName = "MIT";
  };
}) {};

fidget-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/j-hui/fidget.nvim";
    description = "Extensible UI for Neovim notifications and LSP progress messages.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

fifo = callPackage({ buildLuarocksPackage, fetchurl, fetchzip }:
buildLuarocksPackage {
  pname = "fifo";
  version = "0.2-0";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/fifo-0.2-0.rockspec";
    sha256 = "0vr9apmai2cyra2n573nr3dyk929gzcs4nm1096jdxcixmvh2ymq";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/daurnimator/fifo.lua/archive/0.2.zip";
    sha256 = "1800k7h5hxsvm05bjdr65djjml678lwb0661cll78z1ys2037nzn";
  };


  meta = {
    homepage = "https://github.com/daurnimator/fifo.lua";
    description = "A lua library/'class' that implements a FIFO";
    license.fullName = "MIT/X11";
  };
}) {};

fluent = callPackage({ buildLuarocksPackage, cldr, fetchFromGitHub, fetchurl, luaOlder, luaepnf, penlight }:
buildLuarocksPackage {
  pname = "fluent";
  version = "0.2.0-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/fluent-0.2.0-0.rockspec";
    sha256 = "1x3nk8xdf923rvdijr0jx8v6w3wxxfch7ri3kxca0pw80b5bc2fa";
  }).outPath;
  src = fetchFromGitHub {
    owner = "alerque";
    repo = "fluent-lua";
    rev = "v0.2.0";
    hash = "sha256-uDJWhQ/fDD9ZbYOgPk1FDlU3A3DAZw3Ujx92BglFWoo=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ cldr luaepnf penlight ];

  meta = {
    homepage = "https://github.com/alerque/fluent-lua";
    description = "Lua implementation of Project Fluent";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT";
  };
}) {};

funnyfiles-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/aikooo7/funnyfiles.nvim";
    description = "This plugin is a way of creating/deleting files/folders without needing to open a file explorer.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

fzf-lua = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
buildLuarocksPackage {
  pname = "fzf-lua";
  version = "0.0.1243-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/fzf-lua-0.0.1243-1.rockspec";
    sha256 = "1qg36v2gx36k313jisxyf6yjywzqngak2qcx211hd2wzxdnsaxdb";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/ibhagwan/fzf-lua/archive/9a0912d171940e8701d1f65d5ee2b23b810720c1.zip";
    sha256 = "0xzgpng4r9paza87fnxc3cfn331g1pmcayv1vky7jmriy5xsrxh6";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/ibhagwan/fzf-lua";
    description = "Improved fzf.vim written in lua";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "AGPL-3.0";
  };
}) {};

fzy = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
buildLuarocksPackage {
  pname = "fzy";
  version = "1.0.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/fzy-1.0.3-1.rockspec";
    sha256 = "07d07afjs73bl5krfbaqx4pw2wpfrkyw2iksamkfa8dlqn9ajn1a";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/swarn/fzy-lua/archive/v1.0.3.zip";
    sha256 = "0w3alddhn0jd19vmminbi1b79mzlagyl1lygmfpxhzzccdv4vapm";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/swarn/fzy-lua";
    description = "A lua implementation of the fzy fuzzy matching algorithm";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

gitsigns-nvim = callPackage({ buildLuarocksPackage, fetchFromGitHub, lua }:
buildLuarocksPackage {
  pname = "gitsigns.nvim";
  version = "scm-1";

  src = fetchFromGitHub {
    owner = "lewis6991";
    repo = "gitsigns.nvim";
    rev = "035da036e68e509ed158414416c827d022d914bd";
    hash = "sha256-UK3DyvrQ0kLm9wrMQ6tLDoDunoThbY/Yfjn+eCZpuMw=";
  };

  disabled = lua.luaversion != "5.1";

  meta = {
    homepage = "http://github.com/lewis6991/gitsigns.nvim";
    description = "Git signs written in pure lua";
    license.fullName = "MIT/X11";
  };
}) {};

haskell-tools-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
buildLuarocksPackage {
  pname = "haskell-tools.nvim";
  version = "3.1.8-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/haskell-tools.nvim-3.1.8-1.rockspec";
    sha256 = "1jhms5gpah8lk0mn1gx127afmihyaq1fj8qrd6a8yh3wy12k1qxc";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/mrcjkb/haskell-tools.nvim/archive/3.1.8.zip";
    sha256 = "14nk6jyq2y4q93ij56bdjy17h3jlmjwsspw3l6ahvjsl6yg1lv75";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/mrcjkb/haskell-tools.nvim";
    description = "Supercharge your Haskell experience in neovim!";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "GPL-2.0";
  };
}) {};

http = callPackage({ basexx, binaryheap, bit32, buildLuarocksPackage, compat53, cqueues, fetchurl, fetchzip, fifo, lpeg, lpeg_patterns, luaOlder, luaossl }:
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

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ basexx binaryheap bit32 compat53 cqueues fifo lpeg lpeg_patterns luaossl ];

  meta = {
    homepage = "https://github.com/daurnimator/lua-http";
    description = "HTTP library for Lua";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT";
  };
}) {};

image-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder, magick }:
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

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ magick ];

  meta = {
    homepage = "https://github.com/3rd/image.nvim";
    description = "🖼️ Bringing images to Neovim.";
    maintainers = with lib.maintainers; [ teto ];
    license.fullName = "MIT";
  };
}) {};

inspect = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/kikito/inspect.lua";
    description = "Lua table visualizer, ideal for debugging";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

jsregexp = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "jsregexp";
  version = "0.0.7-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/jsregexp-0.0.7-1.rockspec";
    sha256 = "1yx0340h51xk23n0g8irj5c9bs35zy6p1zl5kp7vy2cwxazbipbl";
  }).outPath;
  src = fetchFromGitHub {
    owner = "kmarius";
    repo = "jsregexp";
    rev = "v0.0.7";
    hash = "sha256-aXRGmo6w7jgKlR2BwKhbFGHC0mOTwHfYsh+lvqNuFtQ=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/kmarius/jsregexp";
    description = "javascript (ECMA19) regular expressions for lua";
    license.fullName = "MIT";
  };
}) {};

ldbus = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "ldbus";
  version = "scm-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/ldbus-scm-0.rockspec";
    sha256 = "1c0h6fx7avzh89hl17v6simy1p4mjg8bimlsbjybks0zxznd8rbm";
  }).outPath;
  src = fetchFromGitHub {
    owner = "daurnimator";
    repo = "ldbus";
    rev = "6d4909c983c8a0e2c7384bac8055c628aa524ea2";
    hash = "sha256-8px1eFSxt/SJipxxmjTpGpJO7V0oOK39+nK7itJCCaM=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "https://github.com/daurnimator/ldbus";
    description = "A Lua library to access dbus.";
    license.fullName = "MIT/X11";
  };
}) {};

ldoc = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, markdown, penlight }:
buildLuarocksPackage {
  pname = "ldoc";
  version = "1.5.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/ldoc-1.5.0-1.rockspec";
    sha256 = "1c0yx9j3yqlzxpmspz7n7l1nvh2sww84zhkb1fsbg042sr8h9bxp";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "ldoc";
    rev = "v1.5.0";
    hash = "sha256-Me2LT+UzO8G2vHqG7DjjoCRAtLmhiJHlSEYQGkprxTw=";
  };

  propagatedBuildInputs = [ markdown penlight ];

  meta = {
    homepage = "http://lunarmodules.github.io/ldoc";
    description = "A Lua Documentation Tool";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

lgi = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lgi";
  version = "0.9.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lgi-0.9.2-1.rockspec";
    sha256 = "1gqi07m4bs7xibsy4vx8qgyp3yb1wnh0gdq1cpwqzv35y6hn5ds3";
  }).outPath;
  src = fetchFromGitHub {
    owner = "pavouk";
    repo = "lgi";
    rev = "0.9.2";
    hash = "sha256-UpamUbvqzF0JKV3J0wIiJlV6iedwe823vD0EIm3zKw8=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "http://github.com/pavouk/lgi";
    description = "Lua bindings to GObject libraries";
    license.fullName = "MIT/X11";
  };
}) {};

linenoise = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "linenoise";
  version = "0.9-1";

  src = fetchurl {
    url    = "https://github.com/hoelzro/lua-linenoise/archive/0.9.tar.gz";
    sha256 = "177h6gbq89arwiwxah9943i8hl5gvd9wivnd1nhmdl7d8x0dn76c";
  };

  disabled = luaOlder "5.1";

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

  disabled = lua.luaversion != "5.1";

  meta = {
    homepage = "http://www.myriabit.com/ljsyscall/";
    description = "LuaJIT Linux syscall FFI";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT";
  };
}) {};

lmathx = callPackage({ buildLuarocksPackage, fetchurl }:
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


  meta = {
    homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#lmathx";
    description = "C99 extensions for the math library";
    maintainers = with lib.maintainers; [ alexshpilkin ];
    license.fullName = "Public domain";
  };
}) {};

lmpfrlib = callPackage({ buildLuarocksPackage, fetchurl, luaAtLeast, luaOlder }:
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

  disabled = luaOlder "5.3" || luaAtLeast "5.5";

  meta = {
    homepage = "http://www.circuitwizard.de/lmpfrlib/lmpfrlib.html";
    description = "Lua API for the GNU MPFR library";
    maintainers = with lib.maintainers; [ alexshpilkin ];
    license.fullName = "LGPL";
  };
}) {};

loadkit = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "loadkit";
  version = "1.1.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/loadkit-1.1.0-1.rockspec";
    sha256 = "08fx0xh90r2zvjlfjkyrnw2p95xk1a0qgvlnq4siwdb2mm6fq12l";
  }).outPath;
  src = fetchFromGitHub {
    owner = "leafo";
    repo = "loadkit";
    rev = "v1.1.0";
    hash = "sha256-fw+aoP9+yDpme4qXupE07cV1QGZjb2aU7IOHapG+ihU=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/leafo/loadkit";
    description = "Loadkit allows you to load arbitrary files within the Lua package path";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT";
  };
}) {};

lpeg = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "http://www.inf.puc-rio.br/~roberto/lpeg.html";
    description = "Parsing Expression Grammars For Lua";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

lpeg_patterns = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lpeg }:
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

  propagatedBuildInputs = [ lpeg ];

  meta = {
    homepage = "https://github.com/daurnimator/lpeg_patterns/archive/v0.5.zip";
    description = "a collection of LPEG patterns";
    license.fullName = "MIT";
  };
}) {};

lpeglabel = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/sqmedeiros/lpeglabel/";
    description = "Parsing Expression Grammars For Lua with Labeled Failures";
    license.fullName = "MIT/X11";
  };
}) {};

lrexlib-gnu = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lrexlib-gnu";
  version = "2.9.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lrexlib-gnu-2.9.2-1.rockspec";
    sha256 = "14dp5lzpz2prvimpcbqjygbyh9h791h0ywjknj9wgrjjd62qsy6i";
  }).outPath;
  src = fetchFromGitHub {
    owner = "rrthomas";
    repo = "lrexlib";
    rev = "rel-2-9-2";
    hash = "sha256-DzNDve+xeKb+kAcW+o7GK/RsoDhaDAVAWAhgjISCyZc=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (GNU flavour).";
    license.fullName = "MIT/X11";
  };
}) {};

lrexlib-pcre = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lrexlib-pcre";
  version = "2.9.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lrexlib-pcre-2.9.2-1.rockspec";
    sha256 = "1214ssm6apgprryqvijjjn82ikb27ylq94yijqf7qjyiy6pz7dc1";
  }).outPath;
  src = fetchFromGitHub {
    owner = "rrthomas";
    repo = "lrexlib";
    rev = "rel-2-9-2";
    hash = "sha256-DzNDve+xeKb+kAcW+o7GK/RsoDhaDAVAWAhgjISCyZc=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (PCRE flavour).";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

lrexlib-posix = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lrexlib-posix";
  version = "2.9.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lrexlib-posix-2.9.2-1.rockspec";
    sha256 = "1i11cdvz09a3wjhfjgc88g0mdmdrk13fnhhgskzgm5cmhsdx4s0i";
  }).outPath;
  src = fetchFromGitHub {
    owner = "rrthomas";
    repo = "lrexlib";
    rev = "rel-2-9-2";
    hash = "sha256-DzNDve+xeKb+kAcW+o7GK/RsoDhaDAVAWAhgjISCyZc=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (POSIX flavour).";
    license.fullName = "MIT/X11";
  };
}) {};

lua-cjson = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-cjson";
  version = "2.1.0.10-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-cjson-2.1.0.10-1.rockspec";
    sha256 = "05sp7rq72x4kdkyid1ch0yyscwsi5wk85d2hj6xwssz3h8n8drdg";
  }).outPath;
  src = fetchFromGitHub {
    owner = "openresty";
    repo = "lua-cjson";
    rev = "2.1.0.10";
    hash = "sha256-/SeQro0FaJn91bAGjsVIin+mJF89VUm/G0KyJkV9Qps=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "http://www.kyne.com.au/~mark/software/lua-cjson.php";
    description = "A fast JSON encoding/parsing module";
    license.fullName = "MIT";
  };
}) {};

lua-cmsgpack = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-cmsgpack";
  version = "0.4.0-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-cmsgpack-0.4.0-0.rockspec";
    sha256 = "10cvr6knx3qvjcw1q9v05f2qy607mai7lbq321nx682aa0n1fzin";
  }).outPath;
  src = fetchFromGitHub {
    owner = "antirez";
    repo = "lua-cmsgpack";
    rev = "0.4.0";
    hash = "sha256-oGKX5G3uNGCJOaZpjLmIJYuq5HtdLd9xM/TlmxODCkg=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "http://github.com/antirez/lua-cmsgpack";
    description = "MessagePack C implementation and bindings for Lua 5.1/5.2/5.3";
    license.fullName = "Two-clause BSD";
  };
}) {};

lua-curl = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaAtLeast, luaOlder }:
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

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "https://github.com/Lua-cURL";
    description = "Lua binding to libcurl";
    license.fullName = "MIT/X11";
  };
}) {};

lua-ffi-zlib = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-ffi-zlib";
  version = "0.6-0";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lua-ffi-zlib-0.6-0.rockspec";
    sha256 = "060sac715f1ris13fjv6gwqm0lk6by0a2zhldxd8hdrc0jss8p34";
  }).outPath;
  src = fetchFromGitHub {
    owner = "hamishforbes";
    repo = "lua-ffi-zlib";
    rev = "v0.6";
    hash = "sha256-l3zN6amZ6uUbOl7vt5XF+Uyz0nbDrYgcaQCWRFSN22Q=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/hamishforbes/lua-ffi-zlib";
    description = "A Lua module using LuaJIT's FFI feature to access zlib.";
  };
}) {};

lua-iconv = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/lunarmodules/lua-iconv/";
    description = "Lua binding to the iconv";
    license.fullName = "MIT/X11";
  };
}) {};

lua-lsp = callPackage({ buildLuarocksPackage, dkjson, fetchFromGitHub, fetchurl, inspect, lpeglabel, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "lua-lsp";
  version = "0.1.0-2";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lua-lsp-0.1.0-2.rockspec";
    sha256 = "19jsz00qlgbyims6cg8i40la7v8kr7zsxrrr3dg0kdg0i36xqs6c";
  }).outPath;
  src = fetchFromGitHub {
    owner = "Alloyed";
    repo = "lua-lsp";
    rev = "v0.1.0";
    hash = "sha256-Fy9d6ZS0R48dUpKpgJ9jRujQna5wsE3+StJ8GQyWY54=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.4";
  propagatedBuildInputs = [ dkjson inspect lpeglabel ];

  meta = {
    homepage = "https://github.com/Alloyed/lua-lsp";
    description = "A Language Server implementation for lua, the language";
    license.fullName = "MIT";
  };
}) {};

lua-messagepack = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://fperrad.frama.io/lua-MessagePack/";
    description = "a pure Lua implementation of the MessagePack serialization format";
    license.fullName = "MIT/X11";
  };
}) {};

lua-protobuf = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-protobuf";
  version = "0.5.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-protobuf-0.5.1-1.rockspec";
    sha256 = "1ljn0xwrhcr49k4fzrh0g1q13j16sa6h3wd5q62995q4jlrmnhja";
  }).outPath;
  src = fetchFromGitHub {
    owner = "starwing";
    repo = "lua-protobuf";
    rev = "0.5.1";
    hash = "sha256-Di4fahYlTFfJ2xM6KMs5BY44JV7IKBxxR345uk8X9W8=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/starwing/lua-protobuf";
    description = "protobuf data support for Lua";
    maintainers = with lib.maintainers; [ lockejan ];
    license.fullName = "MIT";
  };
}) {};

lua-resty-http = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-resty-http";
  version = "0.17.2-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-http-0.17.2-0.rockspec";
    sha256 = "10swbq779d1q794d17269v0ln26hblsk7kvxj9s60rx71skzql6s";
  }).outPath;
  src = fetchFromGitHub {
    owner = "ledgetech";
    repo = "lua-resty-http";
    rev = "v0.17.2";
    hash = "sha256-Ph3PpzQYKYMvPvjYwx4TeZ9RYoryMsO6mLpkAq/qlHY=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/ledgetech/lua-resty-http";
    description = "Lua HTTP client cosocket driver for OpenResty / ngx_lua.";
    license.fullName = "2-clause BSD";
  };
}) {};

lua-resty-jwt = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, lua-resty-openssl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-resty-jwt";
  version = "0.2.3-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-jwt-0.2.3-0.rockspec";
    sha256 = "1fxdwfr4pna3fdfm85kin97n53caq73h807wjb59wpqiynbqzc8c";
  }).outPath;
  src = fetchFromGitHub {
    owner = "cdbattags";
    repo = "lua-resty-jwt";
    rev = "v0.2.3";
    hash = "sha256-m8UbvKk2DR8yCYX9Uv5HjXcZDVyVeRlUKp7UiaN/SkA=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ lua-resty-openssl ];

  meta = {
    homepage = "https://github.com/cdbattags/lua-resty-jwt";
    description = "JWT for ngx_lua and LuaJIT.";
    license.fullName = "Apache License Version 2";
  };
}) {};

lua-resty-openidc = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, lua-resty-http, lua-resty-jwt, lua-resty-session, luaOlder }:
buildLuarocksPackage {
  pname = "lua-resty-openidc";
  version = "1.7.6-3";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-openidc-1.7.6-3.rockspec";
    sha256 = "08nq24kxw51xiyyp5jailyqjfsgz4m4fzy4hb7g3fv76vcsf8msp";
  }).outPath;
  src = fetchFromGitHub {
    owner = "zmartzone";
    repo = "lua-resty-openidc";
    rev = "v1.7.6";
    hash = "sha256-1yBmYuFlF/RdOz9csteaqsEEUxVWdwE6IMgS5M9PsJU=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ lua-resty-http lua-resty-jwt lua-resty-session ];

  meta = {
    homepage = "https://github.com/zmartzone/lua-resty-openidc";
    description = "A library for NGINX implementing the OpenID Connect Relying Party (RP) and the OAuth 2.0 Resource Server (RS) functionality";
    license.fullName = "Apache 2.0";
  };
}) {};

lua-resty-openssl = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl }:
buildLuarocksPackage {
  pname = "lua-resty-openssl";
  version = "1.3.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-openssl-1.3.1-1.rockspec";
    sha256 = "1rqsmsnnnz78yb0x2xf7764l3rk54ngk3adm6an4g7dm5kryv33f";
  }).outPath;
  src = fetchFromGitHub {
    owner = "fffonion";
    repo = "lua-resty-openssl";
    rev = "1.3.1";
    hash = "sha256-4h6oIdiMyW9enJToUBtRuUdnKSyWuFFxIDvj4dFRKDs=";
  };


  meta = {
    homepage = "https://github.com/fffonion/lua-resty-openssl";
    description = "No summary";
    license.fullName = "BSD";
  };
}) {};

lua-resty-session = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, lua-ffi-zlib, lua-resty-openssl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-resty-session";
  version = "4.0.5-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-resty-session-4.0.5-1.rockspec";
    sha256 = "0h0kqwna46mrraq310qjb7yigxwv13n4czk24xnqr21czxsskzkg";
  }).outPath;
  src = fetchFromGitHub {
    owner = "bungle";
    repo = "lua-resty-session";
    rev = "v4.0.5";
    hash = "sha256-n0m6/4JnUPoidM7oWKd+ZyNbb/X/h8w21ptCrFaA8SI=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ lua-ffi-zlib lua-resty-openssl ];

  meta = {
    homepage = "https://github.com/bungle/lua-resty-session";
    description = "Session Library for OpenResty - Flexible and Secure";
    license.fullName = "BSD";
  };
}) {};

lua-rtoml = callPackage({ buildLuarocksPackage, fetchFromGitHub, luaOlder, luarocks-build-rust-mlua }:
buildLuarocksPackage {
  pname = "lua-rtoml";
  version = "0.2-0";

  src = fetchFromGitHub {
    owner = "lblasc";
    repo = "lua-rtoml";
    rev = "c83f56b9519d85968d663308e303f384c55c7b18";
    hash = "sha256-PRoaUQSSvzl9VFK+aGHbJqCW37AsO+oFXNYgM0OdIoY=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ luarocks-build-rust-mlua ];

  meta = {
    homepage = "https://github.com/lblasc/lua-rtoml";
    description = "Lua bindings for the Rust toml crate.";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT";
  };
}) {};

lua-subprocess = callPackage({ buildLuarocksPackage, fetchFromGitHub, luaOlder }:
buildLuarocksPackage {
  pname = "subprocess";
  version = "scm-1";

  src = fetchFromGitHub {
    owner = "0x0ade";
    repo = "lua-subprocess";
    rev = "bfa8e97da774141f301cfd1106dca53a30a4de54";
    hash = "sha256-4LiYWB3PAQ/s33Yj/gwC+Ef1vGe5FedWexeCBVSDIV0=";
  };

  disabled = luaOlder "5.1";

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
  version = "0.8-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-term-0.8-1.rockspec";
    sha256 = "1728lj3x8shc5m1yczrl75szq15rnfpzk36n0m49181ly9wxn7s0";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/hoelzro/lua-term/archive/0.08.tar.gz";
    sha256 = "1vfdg5dzqdi3gn6wpc9a3djhsl6fn2ikqdwr8rrqrnd91qwlzycg";
  };


  meta = {
    homepage = "https://github.com/hoelzro/lua-term";
    description = "Terminal functions for Lua";
    license.fullName = "MIT/X11";
  };
}) {};

lua-toml = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-toml";
  version = "2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-toml-2.0-1.rockspec";
    sha256 = "0zd3hrj1ifq89rjby3yn9y96vk20ablljvqdap981navzlbb7zvq";
  }).outPath;
  src = fetchFromGitHub {
    owner = "jonstoler";
    repo = "lua-toml";
    rev = "v2.0.1";
    hash = "sha256-6wCo06Ulmx6HVN2bTrklPqgGiEhDZ1fUfusdS/SDdFI=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/jonstoler/lua-toml";
    description = "toml decoder/encoder for Lua";
    license.fullName = "MIT";
  };
}) {};

lua-utils-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/nvim-neorg/lua-utils.nvim";
    description = "A set of utility functions for Neovim plugins.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

lua-yajl = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-yajl";
  version = "2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-yajl-2.0-1.rockspec";
    sha256 = "0h600zgq5qc9z3cid1kr35q3qb98alg0m3qf0a3mfj33hya6pcxp";
  }).outPath;
  src = fetchFromGitHub {
    owner = "brimworks";
    repo = "lua-yajl";
    rev = "v2.0";
    hash = "sha256-/UhdjTUzd5ZsQG3CaS6i0cYOgkLR4TJCUAcw5yYhYEI=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "http://github.com/brimworks/lua-yajl";
    description = "Integrate the yajl JSON library with Lua.";
    maintainers = with lib.maintainers; [ pstn ];
    license.fullName = "MIT/X11";
  };
}) {};

lua-zlib = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lua-zlib";
  version = "1.2-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-zlib-1.2-2.rockspec";
    sha256 = "1ycjy59w6rkhasqqbiyra0f1sj87fswcz25zwxy4gyv7rrwy5hxd";
  }).outPath;
  src = fetchFromGitHub {
    owner = "brimworks";
    repo = "lua-zlib";
    rev = "v1.2";
    hash = "sha256-3gDYO4KcGUmcJFV22NDXWrFDwHNmPvMp++iXrz+QbC0=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/brimworks/lua-zlib";
    description = "Simple streaming interface to zlib for Lua.";
    maintainers = with lib.maintainers; [ koral ];
    license.fullName = "MIT";
  };
}) {};

lua_cliargs = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lua_cliargs";
  version = "3.0.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua_cliargs-3.0.2-1.rockspec";
    sha256 = "1gp3n9ipaqdk59ilqx1ci5faxmx4dh9sgg3279jb8yfa7wg5b8pf";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "lua_cliargs";
    rev = "v3.0.2";
    hash = "sha256-wL3qBQ8Lu3q8DK2Kaeo1dgzIHd8evaxFYJg47CcQiSg=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/lunarmodules/lua_cliargs.git";
    description = "A command-line argument parsing module for Lua";
    license.fullName = "MIT";
  };
}) {};

luabitop = callPackage({ buildLuarocksPackage, fetchFromGitHub, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luabitop";
  version = "1.0.2-3";

  src = fetchFromGitHub {
    owner = "teto";
    repo = "luabitop";
    rev = "96f0a3d73ae5183d0a81bc2f29326eaa06becbfd";
    hash = "sha256-PrM8ncb3TaqgVhFdRa+rUsJ5WuIzS4/DRqVqj8tCaeg=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.3";

  meta = {
    homepage = "http://bitop.luajit.org/";
    description = "Lua Bit Operations Module";
    license.fullName = "MIT/X license";
  };
}) {};

luacheck = callPackage({ argparse, buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder, luafilesystem }:
buildLuarocksPackage {
  pname = "luacheck";
  version = "1.1.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luacheck-1.1.2-1.rockspec";
    sha256 = "11p7kf7v1b5rhi3m57g2zqwzmnnp79v76gh13b0fg2c78ljkq1k9";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "luacheck";
    rev = "v1.1.2";
    hash = "sha256-AUEHRuldlnuxBWGRzcbjM4zu5IBGfbNEUakPmpS4VIo=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ argparse luafilesystem ];

  meta = {
    homepage = "https://github.com/lunarmodules/luacheck";
    description = "A static analyzer and a linter for Lua";
    license.fullName = "MIT";
  };
}) {};

luacov = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luacov";
  version = "0.15.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luacov-0.15.0-1.rockspec";
    sha256 = "18byfl23c73pazi60hsx0vd74hqq80mzixab76j36cyn8k4ni9db";
  }).outPath;
  src = fetchFromGitHub {
    owner = "keplerproject";
    repo = "luacov";
    rev = "v0.15.0";
    hash = "sha256-cZrsxQyW5Z13cguTzsdJyIMATJUw6GasLItho6wFpSA=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "https://keplerproject.github.io/luacov/";
    description = "Coverage analysis tool for Lua scripts";
    license.fullName = "MIT";
  };
}) {};

luadbi = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luadbi";
  version = "0.7.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luadbi-0.7.3-1.rockspec";
    sha256 = "0lyiwyg6qnnj7d5rxim6b9p68nbszmwhg57xjlvalbcgwgipk1ns";
  }).outPath;
  src = fetchFromGitHub {
    owner = "mwild1";
    repo = "luadbi";
    rev = "v0.7.3";
    hash = "sha256-L2i/e44HvPRhGKH4pUE/6QzO8pHYymHdj2SpHf6YO/I=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-mysql = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaAtLeast, luaOlder, luadbi }:
buildLuarocksPackage {
  pname = "luadbi-mysql";
  version = "0.7.3-1";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/luadbi-mysql-0.7.3-1.rockspec";
    sha256 = "1x0pl6qpdi4vmhxs2076kkxmikbv0asndh8lp34r47lym37hcrr3";
  }).outPath;
  src = fetchFromGitHub {
    owner = "mwild1";
    repo = "luadbi";
    rev = "v0.7.3";
    hash = "sha256-L2i/e44HvPRhGKH4pUE/6QzO8pHYymHdj2SpHf6YO/I=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";
  propagatedBuildInputs = [ luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-postgresql = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaAtLeast, luaOlder, luadbi }:
buildLuarocksPackage {
  pname = "luadbi-postgresql";
  version = "0.7.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luadbi-postgresql-0.7.3-1.rockspec";
    sha256 = "1bnjsgk7cl6wmfhmn8b0av49yabf8flhdi1jhczksvvpf32p77bw";
  }).outPath;
  src = fetchFromGitHub {
    owner = "mwild1";
    repo = "luadbi";
    rev = "v0.7.3";
    hash = "sha256-L2i/e44HvPRhGKH4pUE/6QzO8pHYymHdj2SpHf6YO/I=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";
  propagatedBuildInputs = [ luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luadbi-sqlite3 = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaAtLeast, luaOlder, luadbi }:
buildLuarocksPackage {
  pname = "luadbi-sqlite3";
  version = "0.7.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luadbi-sqlite3-0.7.3-1.rockspec";
    sha256 = "0ppkk1jkxw2fhc4x26h7h2bks51shl3am552phn7all5h3k7h3by";
  }).outPath;
  src = fetchFromGitHub {
    owner = "mwild1";
    repo = "luadbi";
    rev = "v0.7.3";
    hash = "sha256-L2i/e44HvPRhGKH4pUE/6QzO8pHYymHdj2SpHf6YO/I=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";
  propagatedBuildInputs = [ luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
}) {};

luaepnf = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, lpeg, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luaepnf";
  version = "0.3-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaepnf-0.3-2.rockspec";
    sha256 = "0kqmnj11wmfpc9mz04zzq8ab4mnbkrhcgc525wrq6pgl3p5li8aa";
  }).outPath;
  src = fetchFromGitHub {
    owner = "siffiejoe";
    repo = "lua-luaepnf";
    rev = "v0.3";
    hash = "sha256-iZksr6Ljy94D0VO4xSRO9s/VgcURvCfDMX9DOt2IetM=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";
  propagatedBuildInputs = [ lpeg ];

  meta = {
    homepage = "http://siffiejoe.github.io/lua-luaepnf/";
    description = "Extended PEG Notation Format (easy grammars for LPeg)";
    license.fullName = "MIT";
  };
}) {};

luaevent = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/harningt/luaevent";
    description = "libevent binding for Lua";
    license.fullName = "MIT";
  };
}) {};

luaexpat = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "luaexpat";
  version = "1.4.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaexpat-1.4.1-1.rockspec";
    sha256 = "1abwd385x7wnza7qqz5s4aj6m2l1c23pjmbgnpq73q0s17pn1h0c";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "luaexpat";
    rev = "1.4.1";
    hash = "sha256-SnI+a7555R/EFFdnrvJohP6uzwQiMNQPqgp0jxAI178=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://lunarmodules.github.io/luaexpat";
    description = "XML Expat parsing";
    maintainers = with lib.maintainers; [ arobyn flosse ];
    license.fullName = "MIT/X11";
  };
}) {};

luaffi = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "luaffi";
  version = "scm-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaffi-scm-1.rockspec";
    sha256 = "1nia0g4n1yv1sbv5np572y8yfai56a8bnscir807s5kj5bs0xhxm";
  }).outPath;
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "luaffifb";
    rev = "a1cb731b08c91643b0665935eb5622b3d621211b";
    hash = "sha256-wRjAtEEy8KSlIoi/IIutL73Vbm1r+zKs26dEP7gzR1o=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/facebook/luaffifb";
    description = "FFI library for calling C functions from lua";
    license.fullName = "BSD";
  };
}) {};

luafilesystem = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "luafilesystem";
  version = "1.8.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luafilesystem-1.8.0-1.rockspec";
    sha256 = "18nkaks0b75dmycljg5vljap5w8d0ysdkg96yl5szgzr7nzrymfa";
  }).outPath;
  src = fetchFromGitHub {
    owner = "keplerproject";
    repo = "luafilesystem";
    rev = "v1_8_0";
    hash = "sha256-pEA+Z1pkykWLTT6NHQ5lo8roOh2P0fiHtnK+byTkF5o=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/keplerproject/luafilesystem";
    description = "File System Library for the Lua Programming Language";
    maintainers = with lib.maintainers; [ flosse ];
    license.fullName = "MIT/X11";
  };
}) {};

lualdap = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "lualdap";
  version = "1.4.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lualdap-1.4.0-1.rockspec";
    sha256 = "0n924gxm6ccr9hjk4bi5z70vgh7g75dl7293pab41a2qcrlsj9nk";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lualdap";
    repo = "lualdap";
    rev = "v1.4.0";
    hash = "sha256-u91T7RlRa87CbYXZLhrzcpVvZWsCnQObmbS86kfsAHc=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://lualdap.github.io/lualdap/";
    description = "A Lua interface to the OpenLDAP library";
    maintainers = with lib.maintainers; [ aanderse ];
    license.fullName = "MIT";
  };
}) {};

lualogging = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luasocket }:
buildLuarocksPackage {
  pname = "lualogging";
  version = "1.8.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lualogging-1.8.2-1.rockspec";
    sha256 = "164c4xgwkv2ya8fbb22wm48ywc4gx939b574r6bgl8zqayffdqmx";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "lualogging";
    rev = "v1.8.2";
    hash = "sha256-RIblf2C9H6Iajzc9aqnvrK4xq8FAHq9InTO6m3aM5dc=";
  };

  propagatedBuildInputs = [ luasocket ];

  meta = {
    homepage = "https://github.com/lunarmodules/lualogging";
    description = "A simple API to use logging features";
    license.fullName = "MIT/X11";
  };
}) {};

luaossl = callPackage({ buildLuarocksPackage, fetchurl, fetchzip }:
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


  meta = {
    homepage = "http://25thandclement.com/~william/projects/luaossl.html";
    description = "Most comprehensive OpenSSL module in the Lua universe.";
    license.fullName = "MIT/X11";
  };
}) {};

luaprompt = callPackage({ argparse, buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "luaprompt";
  version = "0.8-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luaprompt-0.8-1.rockspec";
    sha256 = "17v7yqkvm4rxszqvqk3f6a6vqysh80p18l1ryif79bc7ic948br4";
  }).outPath;
  src = fetchFromGitHub {
    owner = "dpapavas";
    repo = "luaprompt";
    rev = "v0.8";
    hash = "sha256-GdI5sj7FBeb9q23oxVOzT+yVhMYTnggaN8Xt/z/2xZo=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ argparse ];

  meta = {
    homepage = "https://github.com/dpapavas/luaprompt";
    description = "A Lua command prompt with pretty-printing and auto-completion";
    license.fullName = "MIT/X11";
  };
}) {};

luaposix = callPackage({ bit32, buildLuarocksPackage, fetchurl, fetchzip, luaAtLeast, luaOlder }:
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

  disabled = luaOlder "5.1" || luaAtLeast "5.4";
  propagatedBuildInputs = [ bit32 ];

  meta = {
    homepage = "http://github.com/luaposix/luaposix/";
    description = "Lua bindings for POSIX";
    maintainers = with lib.maintainers; [ vyp lblasc ];
    license.fullName = "MIT/X11";
  };
}) {};

luarepl = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/hoelzro/lua-repl";
    description = "A reusable REPL component for Lua, written in Lua";
    license.fullName = "MIT/X11";
  };
}) {};

luarocks = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl }:
buildLuarocksPackage {
  pname = "luarocks";
  version = "3.11.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luarocks-3.11.0-1.rockspec";
    sha256 = "0pi55445dskpw6nhrq52589h4v39fsf23c0kp8d4zg2qaf6y2n38";
  }).outPath;
  src = fetchFromGitHub {
    owner = "luarocks";
    repo = "luarocks";
    rev = "v3.11.0";
    hash = "sha256-mSwwBuLWoMT38iYaV/BTdDmmBz4heTRJzxBHC0Vrvc4=";
  };


  meta = {
    homepage = "http://www.luarocks.org";
    description = "A package manager for Lua modules.";
    maintainers = with lib.maintainers; [ mrcjkb teto ];
    license.fullName = "MIT";
  };
}) {};

luarocks-build-rust-mlua = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl }:
buildLuarocksPackage {
  pname = "luarocks-build-rust-mlua";
  version = "0.2.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luarocks-build-rust-mlua-0.2.0-1.rockspec";
    sha256 = "0mpxj2wpzgqffic1j6agisaawbfhh16gis29x6y60kyjq446mv0z";
  }).outPath;
  src = fetchFromGitHub {
    owner = "khvzak";
    repo = "luarocks-build-rust-mlua";
    rev = "0.2.0";
    hash = "sha256-f6trXv2/gzbitLXwHHrZnowEA/V5Yjb3Q9YlYr+9NBw=";
  };


  meta = {
    homepage = "https://github.com/khvzak/luarocks-build-rust-mlua";
    description = "A LuaRocks build backend for Lua modules written in Rust using mlua";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

luarocks-build-treesitter-parser = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder, luafilesystem }:
buildLuarocksPackage {
  pname = "luarocks-build-treesitter-parser";
  version = "2.0.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luarocks-build-treesitter-parser-2.0.0-1.rockspec";
    sha256 = "0ylax1r0yl5k742p8n0fq5irs2r632npigqp1qckfx7kwi89gxhb";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/archive/v2.0.0.zip";
    sha256 = "0gqiwk7dk1xn5n2m0iq5c7xkrgyaxwyd1spb573l289gprvlrbn5";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luafilesystem ];

  meta = {
    homepage = "https://github.com/nvim-neorocks/luarocks-build-treesitter-parser";
    description = "A luarocks build backend for tree-sitter parsers.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

luasec = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder, luasocket }:
buildLuarocksPackage {
  pname = "luasec";
  version = "1.3.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasec-1.3.2-1.rockspec";
    sha256 = "09nqs60cmbq1bi70cdh7v5xjnlsm2mrxv9pmbbvczijvz184jh33";
  }).outPath;
  src = fetchFromGitHub {
    owner = "brunoos";
    repo = "luasec";
    rev = "v1.3.2";
    hash = "sha256-o3uiZQnn/ID1qAgpZAqA4R3fWWk+Ajcgx++iNu1yLWc=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ luasocket ];

  meta = {
    homepage = "https://github.com/brunoos/luasec/wiki";
    description = "A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket.";
    maintainers = with lib.maintainers; [ flosse ];
    license.fullName = "MIT";
  };
}) {};

luasnip = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, jsregexp, luaOlder }:
buildLuarocksPackage {
  pname = "luasnip";
  version = "2.3.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasnip-2.3.0-1.rockspec";
    sha256 = "022srpvwwbms8i97mdhkwq0yg0pfjm7a6673iyf7cr1xj15pq23v";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/L3MON4D3/LuaSnip/archive/v2.3.0.zip";
    sha256 = "0bbackpym8k11gm32iwwzqjnqanpralanfjkl4lrs33xl7lsylqk";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ jsregexp ];

  meta = {
    homepage = "https://github.com/L3MON4D3/LuaSnip";
    description = "Snippet Engine for Neovim written in Lua.";
    license.fullName = "Apache-2.0";
  };
}) {};

luasocket = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "luasocket";
  version = "3.1.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasocket-3.1.0-1.rockspec";
    sha256 = "0wg9735cyz2gj7r9za8yi83w765g0f4pahnny7h0pdpx58pgfx4r";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "luasocket";
    rev = "v3.1.0";
    hash = "sha256-sKSzCrQpS+9reN9IZ4wkh4dB50wiIfA87xN4u1lyHo4=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/lunarmodules/luasocket";
    description = "Network support for the Lua language";
    license.fullName = "MIT";
  };
}) {};

luasql-sqlite3 = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "luasql-sqlite3";
  version = "2.6.1-3";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasql-sqlite3-2.6.1-3.rockspec";
    sha256 = "1qf8cx4cmsngwp65ksdsf5dsv6yhb4qwdrd2lkpyqaq6p55jfkyb";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "luasql";
    rev = "2.6.0";
    hash = "sha256-bRddE9K9f6TFBD2nY5kkS0BzXilfUP7Z358QLPfna+I=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://lunarmodules.github.io/luasql/";
    description = "Database connectivity for Lua (SQLite3 driver)";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

luassert = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder, say }:
buildLuarocksPackage {
  pname = "luassert";
  version = "1.9.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luassert-1.9.0-1.rockspec";
    sha256 = "1bkzr03190p33lprgy51nl84aq082fyc3f7s3wkk7zlay4byycxd";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "luassert";
    rev = "v1.9.0";
    hash = "sha256-jjdB95Vr5iVsh5T7E84WwZMW6/5H2k2R/ny2VBs2l3I=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ say ];

  meta = {
    homepage = "https://lunarmodules.github.io/busted/";
    description = "Lua assertions extension";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

luasystem = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "luasystem";
  version = "0.3.0-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luasystem-0.3.0-2.rockspec";
    sha256 = "02kwkcwf81v6ncxl1ng2pxlhalz78q2476snh5xxv3wnwqwbp10a";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "luasystem";
    rev = "v0.3.0";
    hash = "sha256-oTFH0x94gSo1sqk1GsDheoVrjJHxFWZLtlJ45GwupoU=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/lunarmodules/luasystem";
    description = "Platform independent system calls for Lua.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

luatext = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "luatext";
  version = "1.2.1-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luatext-1.2.1-0.rockspec";
    sha256 = "12ia4ibihd537mjmvdasnwgkinaygqwk03bsj3s0qrfhy6yz84ka";
  }).outPath;
  src = fetchFromGitHub {
    owner = "f4z3r";
    repo = "luatext";
    rev = "v1.2.1";
    hash = "sha256-StxCmjSSy3ok0hNkKTQyq4yS1LfX980R5pULCUjLPek=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/f4z3r/luatext/tree/main";
    description = "A small library to print colored text";
    license.fullName = "MIT";
  };
}) {};

luaunbound = callPackage({ buildLuarocksPackage, fetchurl, luaAtLeast, luaOlder }:
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

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "https://www.zash.se/luaunbound.html";
    description = "A binding to libunbound";
    license.fullName = "MIT";
  };
}) {};

luaunit = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaAtLeast, luaOlder }:
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

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "http://github.com/bluebird75/luaunit";
    description = "A unit testing framework for Lua";
    maintainers = with lib.maintainers; [ lockejan ];
    license.fullName = "BSD";
  };
}) {};

luautf8 = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "http://github.com/starwing/luautf8";
    description = "A UTF-8 support module for Lua";
    maintainers = with lib.maintainers; [ pstn ];
    license.fullName = "MIT";
  };
}) {};

luazip = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "luazip";
  version = "1.2.7-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luazip-1.2.7-1.rockspec";
    sha256 = "1wxy3p2ksaq4s8lg925mi9cvbh875gsapgkzm323dr8qaxxg7mba";
  }).outPath;
  src = fetchFromGitHub {
    owner = "mpeterv";
    repo = "luazip";
    rev = "1.2.7";
    hash = "sha256-pAuXdvF2hM3ApvOg5nn9EHTGlajujHMtHEoN3Sj+mMo=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.4";

  meta = {
    homepage = "https://github.com/mpeterv/luazip";
    description = "Library for reading files inside zip files";
    license.fullName = "MIT";
  };
}) {};

lush-nvim = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "lush.nvim";
  version = "scm-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lush.nvim-scm-1.rockspec";
    sha256 = "0ivir5p3mmv051pyya2hj1yrnflrv8bp38dx033i3kzfbpyg23ca";
  }).outPath;
  src = fetchFromGitHub {
    owner = "rktjmp";
    repo = "lush.nvim";
    rev = "7c0e27f50901481fe83b974493c4ea67a4296aeb";
    hash = "sha256-GVGIZPBrunaWexwdnkbc0LxM3xMHslrwON2FunN3TDE=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.4";

  meta = {
    homepage = "https://github.com/rktjmp/lush.nvim";
    description = "Define Neovim themes as a DSL in lua, with real-time feedback.";
    maintainers = with lib.maintainers; [ teto ];
    license.fullName = "MIT/X11";
  };
}) {};

luuid = callPackage({ buildLuarocksPackage, fetchurl, luaAtLeast, luaOlder }:
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

  disabled = luaOlder "5.2" || luaAtLeast "5.4";

  meta = {
    homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#luuid";
    description = "A library for UUID generation";
    license.fullName = "Public domain";
  };
}) {};

luv = callPackage({ buildLuarocksPackage, cmake, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "luv";
  version = "1.48.0-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/luv-1.48.0-2.rockspec";
    sha256 = "0353bjn9z90a1hd7rksdfrd9fbdd31hbvdaxr1fb0fh0bc1cpy94";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/luvit/luv/releases/download/1.48.0-2/luv-1.48.0-2.tar.gz";
    sha256 = "2c3a1ddfebb4f6550293a40ee789f7122e97647eede51511f57203de48c03b7a";
  };

  disabled = luaOlder "5.1";
  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/luvit/luv";
    description = "Bare libuv bindings for lua";
    license.fullName = "Apache 2.0";
  };
}) {};

lyaml = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaAtLeast, luaOlder }:
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

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "http://github.com/gvvaughan/lyaml";
    description = "libYAML binding for Lua";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT/X11";
  };
}) {};

magick = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, lua }:
buildLuarocksPackage {
  pname = "magick";
  version = "1.6.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/magick-1.6.0-1.rockspec";
    sha256 = "1pg150xsxnqvlhxpiy17s9hm4dkc84v46mlwi9rhriynqz8qks9w";
  }).outPath;
  src = fetchFromGitHub {
    owner = "leafo";
    repo = "magick";
    rev = "v1.6.0";
    hash = "sha256-gda+vLrWyMQ553jVCIRl1qYTS/rXsGhxrBsrJyI8EN4=";
  };

  disabled = lua.luaversion != "5.1";

  meta = {
    homepage = "https://github.com/leafo/magick.git";
    description = "Lua bindings to ImageMagick & GraphicsMagick for LuaJIT using FFI";
    maintainers = with lib.maintainers; [ donovanglover ];
    license.fullName = "MIT";
  };
}) {};

markdown = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "markdown";
  version = "0.33-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/markdown-0.33-1.rockspec";
    sha256 = "02sixijfi6av8h59kx3ngrhygjn2sx1c85c0qfy20gxiz72wi1pl";
  }).outPath;
  src = fetchFromGitHub {
    owner = "mpeterv";
    repo = "markdown";
    rev = "0.33";
    hash = "sha256-PgRGiSwDODSyNSgeN7kNOCZwjLbGf1Qts/jrfLGYKwU=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.4";

  meta = {
    homepage = "https://github.com/mpeterv/markdown";
    description = "Markdown text-to-html markup system.";
    license.fullName = "MIT/X11";
  };
}) {};

mediator_lua = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "http://olivinelabs.com/mediator_lua/";
    description = "Event handling through channels";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

middleclass = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/kikito/middleclass";
    description = "A simple OOP library for Lua";
    license.fullName = "MIT";
  };
}) {};

mimetypes = callPackage({ buildLuarocksPackage, fetchurl, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github/lunarmodules/lua-mimetypes/";
    description = "A simple library for looking up the MIME types of files.";
    license.fullName = "MIT/X11";
  };
}) {};

moonscript = callPackage({ argparse, buildLuarocksPackage, fetchFromGitHub, lpeg, luaOlder, luafilesystem }:
buildLuarocksPackage {
  pname = "moonscript";
  version = "dev-1";

  src = fetchFromGitHub {
    owner = "leafo";
    repo = "moonscript";
    rev = "d5341c9093c49d3724072b209cde28b5cb0f47c9";
    hash = "sha256-sVMhqCzGhfEGoFueVINx9hnnE5vNN61S6t3CXGBnxcA=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ argparse lpeg luafilesystem ];

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
  version = "1.0.12-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/mpack-1.0.12-0.rockspec";
    sha256 = "01jr8vvkqdvadr5kpgsd17gjyz729hbd609qsm682ylggabgqsyy";
  }).outPath;
  src = fetchurl {
    url    = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.12/libmpack-lua-1.0.12.tar.gz";
    sha256 = "1gzqks9cq3krd9rs3dq9jm1m23pjpqjv9ymkxj9gbyjcy6qn5dh6";
  };


  meta = {
    homepage = "https://github.com/libmpack/libmpack-lua";
    description = "Lua binding to libmpack";
    license.fullName = "MIT";
  };
}) {};

neotest = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder, nvim-nio, plenary-nvim }:
buildLuarocksPackage {
  pname = "neotest";
  version = "5.2.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/neotest-5.2.3-1.rockspec";
    sha256 = "16pwkwv2dmi9aqhp6bdbgwhksi891iz73rvksqmv136jx6fi7za1";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neotest/neotest/archive/5caac5cc235d495a2382bc2980630ef36ac87032.zip";
    sha256 = "1i1d6m17wf3p76nm75jk4ayd4zyhslmqi2pc7j8qx87391mnz2c4";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ nvim-nio plenary-nvim ];

  meta = {
    homepage = "https://github.com/nvim-neotest/neotest";
    description = "An extensible framework for interacting with tests within NeoVim.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

nlua = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
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

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/mfussenegger/nlua";
    description = "Neovim as Lua interpreter";
    maintainers = with lib.maintainers; [ teto ];
    license.fullName = "GPL-3.0";
  };
}) {};

nui-nvim = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl }:
buildLuarocksPackage {
  pname = "nui.nvim";
  version = "0.3.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/nui.nvim-0.3.0-1.rockspec";
    sha256 = "0ng75wzbc0bn4zgwqk7dx5hazybfqxpjfzp7k2syh7kajmsy8z8b";
  }).outPath;
  src = fetchFromGitHub {
    owner = "MunifTanjim";
    repo = "nui.nvim";
    rev = "0.3.0";
    hash = "sha256-L0ebXtv794357HOAgT17xlEJsmpqIHGqGlYfDB20WTo=";
  };


  meta = {
    homepage = "https://github.com/MunifTanjim/nui.nvim";
    description = "UI Component Library for Neovim.";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

nvim-cmp = callPackage({ buildLuarocksPackage, fetchFromGitHub, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "nvim-cmp";
  version = "scm-1";

  src = fetchFromGitHub {
    owner = "hrsh7th";
    repo = "nvim-cmp";
    rev = "8f3c541407e691af6163e2447f3af1bd6e17f9a3";
    hash = "sha256-rz+JMd/hsUEDNVan2sCuEGtbsOVi6oRmPtps+7qSXQE=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.4";

  meta = {
    homepage = "https://github.com/hrsh7th/nvim-cmp";
    description = "A completion plugin for neovim";
    license.fullName = "MIT";
  };
}) {};

nvim-nio = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
buildLuarocksPackage {
  pname = "nvim-nio";
  version = "1.9.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/nvim-nio-1.9.0-1.rockspec";
    sha256 = "0hwjkz0pjd8dfc4l7wk04ddm8qzrv5m15gskhz9gllb4frnk6hik";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neotest/nvim-nio/archive/v1.9.0.zip";
    sha256 = "0y3afl42z41ymksk29al5knasmm9wmqzby860x8zj0i0mfb1q5k5";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/nvim-neotest/nvim-nio";
    description = "A library for asynchronous IO in Neovim";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

pathlib-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder, nvim-nio }:
buildLuarocksPackage {
  pname = "pathlib.nvim";
  version = "2.2.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/pathlib.nvim-2.2.2-1.rockspec";
    sha256 = "04dklc0ibl6dbfckmkpj2s1gvjfmr0k2hyagw37rxypifncrffkr";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/pysan3/pathlib.nvim/archive/v2.2.2.zip";
    sha256 = "10jhbdffaw1rh1qppzllmy96dbsn741bk46mph5kxpjq4ldx27hz";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ nvim-nio ];

  meta = {
    homepage = "https://pysan3.github.io/pathlib.nvim/";
    description = "OS Independent, ultimate solution to path handling in neovim.";
    license.fullName = "MPL-2.0";
  };
}) {};

penlight = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder, luafilesystem }:
buildLuarocksPackage {
  pname = "penlight";
  version = "1.14.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/penlight-1.14.0-1.rockspec";
    sha256 = "1zmibf0pgcnf0lj1xmxs0srbyy1cswvb9g1jajy9lhicnpqqlgvh";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "penlight";
    rev = "1.14.0";
    hash = "sha256-4zAt0GgQEkg9toaUaDn3ST3RvjLUDsuOzrKi9lhq0fQ=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ luafilesystem ];

  meta = {
    homepage = "https://lunarmodules.github.io/penlight";
    description = "Lua utility libraries loosely based on the Python standard libraries";
    maintainers = with lib.maintainers; [ alerque ];
    license.fullName = "MIT/X11";
  };
}) {};

plenary-nvim = callPackage({ buildLuarocksPackage, fetchFromGitHub, luaAtLeast, luaOlder, luassert }:
buildLuarocksPackage {
  pname = "plenary.nvim";
  version = "scm-1";

  src = fetchFromGitHub {
    owner = "nvim-lua";
    repo = "plenary.nvim";
    rev = "08e301982b9a057110ede7a735dd1b5285eb341f";
    hash = "sha256-vy0MXEoSM4rvYpfwbc2PnilvMOA30Urv0FAxjXuvqQ8=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.4";
  propagatedBuildInputs = [ luassert ];

  meta = {
    homepage = "http://github.com/nvim-lua/plenary.nvim";
    description = "lua functions you don't want to write ";
    license.fullName = "MIT/X11";
  };
}) {};

psl = callPackage({ buildLuarocksPackage, fetchurl, fetchzip }:
buildLuarocksPackage {
  pname = "psl";
  version = "0.3-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/psl-0.3-0.rockspec";
    sha256 = "1x7sc8n780k67v31bvqqxhh6ihy0k91zmp6xcxmkifr0gd008x9z";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/daurnimator/lua-psl/archive/v0.3.zip";
    sha256 = "1x9zskjn6fp9343w9314104128ik4lbk98pg6zfhl1v35107m1jx";
  };


  meta = {
    homepage = "https://github.com/daurnimator/lua-psl";
    description = "Bindings to libpsl, a C library that handles the Public Suffix List (PSL)";
    license.fullName = "MIT";
  };
}) {};

rapidjson = callPackage({ buildLuarocksPackage, cmake, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "rapidjson";
  version = "0.7.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rapidjson-0.7.1-1.rockspec";
    sha256 = "01lbsn9rckdyx0va7nm9dammic9117kxiawp55yg2h5q3p978d41";
  }).outPath;
  src = fetchFromGitHub {
    owner = "xpol";
    repo = "lua-rapidjson";
    rev = "v0.7.1";
    hash = "sha256-y/czEVPtCt4uN1n49Qi7BrgZmkG+SDXlM5D2GvvO2qg=";
  };

  disabled = luaOlder "5.1";
  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/xpol/lua-rapidjson";
    description = "Json module based on the very fast RapidJSON.";
    license.fullName = "MIT";
  };
}) {};

rest-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, lua-curl, luaOlder, mimetypes, nvim-nio, xml2lua }:
buildLuarocksPackage {
  pname = "rest.nvim";
  version = "2.0.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rest.nvim-2.0.1-1.rockspec";
    sha256 = "1ra76wnhi4nh56amyd8zqmg0mpsnhp3m41m3iyiq4hp1fah6nbqb";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/rest-nvim/rest.nvim/archive/v2.0.1.zip";
    sha256 = "09rs04d5h061zns1kdfycryx4ll8ix15q3ybpmqsdyp2gn8l77df";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ lua-curl mimetypes nvim-nio xml2lua ];

  meta = {
    homepage = "https://github.com/rest-nvim/rest.nvim";
    description = "A fast Neovim http client written in Lua";
    maintainers = with lib.maintainers; [ teto ];
    license.fullName = "GPL-3.0";
  };
}) {};

rocks-config-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder, rocks-nvim }:
buildLuarocksPackage {
  pname = "rocks-config.nvim";
  version = "1.5.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rocks-config.nvim-1.5.0-1.rockspec";
    sha256 = "14rj1p7grmdhi3xm683c3c441xxcldhi5flh6lg1fab1rm9mij6b";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorocks/rocks-config.nvim/archive/v1.5.0.zip";
    sha256 = "0kpvd9ddj1vhkz54ckqsym4fbj1krzpp8cslb20k8qk2n1ccjynv";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ rocks-nvim ];

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

rocks-git-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder, nvim-nio, rocks-nvim }:
buildLuarocksPackage {
  pname = "rocks-git.nvim";
  version = "1.4.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rocks-git.nvim-1.4.0-1.rockspec";
    sha256 = "04zx6yvp5pg306wqaw6fymqci5qnzpzg27xjrycflcyxxq4xmnmg";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorocks/rocks-git.nvim/archive/v1.4.0.zip";
    sha256 = "0yjigf9pzy53yylznnnb68dwmylx9a3qv84kdc2whsf4cj23m2nj";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ nvim-nio rocks-nvim ];

  meta = {
    homepage = "https://github.com/nvim-neorocks/rocks-git.nvim";
    description = "Use rocks.nvim to install plugins from git!";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "GPL-3.0";
  };
}) {};

rocks-nvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, fidget-nvim, fzy, luaOlder, nvim-nio, rtp-nvim, toml-edit }:
buildLuarocksPackage {
  pname = "rocks.nvim";
  version = "2.26.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rocks.nvim-2.26.0-1.rockspec";
    sha256 = "1piypyxq1c6l203f3w8z4fhfi649h5ppl58lckvxph9dvidg11lf";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorocks/rocks.nvim/archive/v2.26.0.zip";
    sha256 = "10wck99dfwxv49pkd9pva7lqr4a79zccbqvb75qbxkgnj0yd5awc";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ fidget-nvim fzy nvim-nio rtp-nvim toml-edit ];

  meta = {
    homepage = "https://github.com/nvim-neorocks/rocks.nvim";
    description = "Neovim plugin management inspired by Cargo, powered by luarocks";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "GPL-3.0";
  };
}) {};


rtp-nvim = callPackage ({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
buildLuarocksPackage {
  pname = "rtp.nvim";
  version = "1.0.0-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rtp.nvim-1.0.0-1.rockspec";
    sha256 = "0ddlwhk62g3yx1ysddsmlggfqv0hj7dljgczfwij1ijbz7qyp3hy";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorocks/rtp.nvim/archive/v1.0.0.zip";
    sha256 = "1kx7qzdz8rpwsjcp63wwn619nrkxn6xd0nr5pfm3g0z4072nnpzn";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/nvim-neorocks/rtp.nvim";
    description = "Source plugin and ftdetect directories on the Neovim runtimepath.";
    license.fullName = "GPL-3.0";
  };
}) {};

rustaceanvim = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
buildLuarocksPackage {
  pname = "rustaceanvim";
  version = "4.22.8-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/rustaceanvim-4.22.8-1.rockspec";
    sha256 = "18hghs9v9j3kv3fxwdp7qk9vhbxn4c8xd8pyxwnyjq5ad7ninr82";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/mrcjkb/rustaceanvim/archive/4.22.8.zip";
    sha256 = "1n9kqr8xdqamc8hd8a155h7rzyda8bz39n0zdgdw0j8hqc214vmm";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/mrcjkb/rustaceanvim";
    description = "Supercharge your Rust experience in Neovim! A heavily modified fork of rust-tools.nvim";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "GPL-2.0";
  };
}) {};

say = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "say";
  version = "1.4.1-3";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/say-1.4.1-3.rockspec";
    sha256 = "0iibmq5m5092y168banckgs15ngj2yjx11n40fyk7jly4pbasljq";
  }).outPath;
  src = fetchFromGitHub {
    owner = "lunarmodules";
    repo = "say";
    rev = "v1.4.1";
    hash = "sha256-IjNkK1leVtYgbEjUqguVMjbdW+0BHAOCE0pazrVuF50=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://lunarmodules.github.io/say";
    description = "Lua string hashing/indexing library";
    license.fullName = "MIT";
  };
}) {};

serpent = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "serpent";
  version = "0.30-2";
  knownRockspec = (fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/serpent-0.30-2.rockspec";
    sha256 = "01696wwp1m8jlcj0y1wwscnz3cpcjdvm8pcnc6c6issa2s4544vr";
  }).outPath;
  src = fetchFromGitHub {
    owner = "pkulchenko";
    repo = "serpent";
    rev = "0.30";
    hash = "sha256-aCP/Lk11wdnqXzntgNlyZz1LkLgZApcvDiA//LLzAGE=";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "https://github.com/pkulchenko/serpent";
    description = "Lua serializer and pretty printer";
    maintainers = with lib.maintainers; [ lockejan ];
    license.fullName = "MIT";
  };
}) {};

sqlite = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luv }:
buildLuarocksPackage {
  pname = "sqlite";
  version = "v1.2.2-0";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/sqlite-v1.2.2-0.rockspec";
    sha256 = "0jxsl9lpxsbzc6s5bwmh27mglkqz1299lz68vfxayvailwl3xbxm";
  }).outPath;
  src = fetchFromGitHub {
    owner = "tami5";
    repo = "sqlite.lua";
    rev = "v1.2.2";
    hash = "sha256-NUjZkFawhUD0oI3pDh/XmVwtcYyPqa+TtVbl3k13cTI=";
  };

  propagatedBuildInputs = [ luv ];

  meta = {
    homepage = "https://github.com/tami5/sqlite.lua";
    description = "SQLite/LuaJIT binding and a highly opinionated wrapper for storing, retrieving, caching, and persisting [SQLite] databases";
    license.fullName = "MIT";
  };
}) {};

std-_debug = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaAtLeast, luaOlder }:
buildLuarocksPackage {
  pname = "std._debug";
  version = "1.0.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/std._debug-1.0.1-1.rockspec";
    sha256 = "0mr9hgzfr9v37da9rfys2wjq48hi3lv27i3g38433dlgbxipsbc4";
  }).outPath;
  src = fetchzip {
    url    = "http://github.com/lua-stdlib/_debug/archive/v1.0.1.zip";
    sha256 = "19vfpv389q79vgxwhhr09l6l6hf6h2yjp09zvnp0l07ar4v660pv";
  };

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "http://lua-stdlib.github.io/_debug";
    description = "Debug Hints Library";
    license.fullName = "MIT/X11";
  };
}) {};

std-normalize = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaAtLeast, luaOlder, std-_debug }:
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

  disabled = luaOlder "5.1" || luaAtLeast "5.5";
  propagatedBuildInputs = [ std-_debug ];

  meta = {
    homepage = "https://lua-stdlib.github.io/normalize";
    description = "Normalized Lua Functions";
    license.fullName = "MIT/X11";
  };
}) {};

stdlib = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaAtLeast, luaOlder }:
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

  disabled = luaOlder "5.1" || luaAtLeast "5.5";

  meta = {
    homepage = "http://lua-stdlib.github.io/lua-stdlib";
    description = "General Lua Libraries";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
}) {};

teal-language-server = callPackage({ buildLuarocksPackage, cyan, dkjson, fetchFromGitHub, fetchurl, luafilesystem }:
buildLuarocksPackage {
  pname = "teal-language-server";
  version = "dev-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/teal-language-server-dev-1.rockspec";
    sha256 = "01l44c6bknz7ff9xqgich31hlb0yk4ms5k1hs4rhm3cs95s5vlzc";
  }).outPath;
  src = fetchFromGitHub {
    owner = "teal-language";
    repo = "teal-language-server";
    rev = "67b5d7cad60b9df472851a2c61591f2aab97da47";
    hash = "sha256-fUuOjJrwpLU1YoJm3yn+X15ioRf4GZoi6323On1W2Io=";
  };

  propagatedBuildInputs = [ cyan dkjson luafilesystem ];

  meta = {
    homepage = "https://github.com/teal-language/teal-language-server";
    description = "A language server for the Teal language";
    license.fullName = "MIT";
  };
}) {};

telescope-manix = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder, telescope-nvim }:
buildLuarocksPackage {
  pname = "telescope-manix";
  version = "1.0.2-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/telescope-manix-1.0.2-1.rockspec";
    sha256 = "0a5cg3kx2pv8jsr0jdpxd1ahprh55n12ggzlqiailyyskzpx94bl";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/mrcjkb/telescope-manix/archive/1.0.2.zip";
    sha256 = "0y3n270zkii123r3987xzvp194dl0q1hy234v95w7l48cf4v495k";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ telescope-nvim ];

  meta = {
    homepage = "https://github.com/mrcjkb/telescope-manix";
    description = "A telescope.nvim extension for Manix - A fast documentation searcher for Nix";
    license.fullName = "GPL-2.0";
  };
}) {};

telescope-nvim = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, lua, plenary-nvim }:
buildLuarocksPackage {
  pname = "telescope.nvim";
  version = "scm-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/telescope.nvim-scm-1.rockspec";
    sha256 = "07mjkv1nv9b3ifxk2bbpbhvp0awblyklyz6aaqw418x4gm4q1g35";
  }).outPath;
  src = fetchFromGitHub {
    owner = "nvim-telescope";
    repo = "telescope.nvim";
    rev = "35f94f0ef32d70e3664a703cefbe71bd1456d899";
    hash = "sha256-AtvZ7b2bg+Iaei4rRzTBYf76vHJH2Yq5tJAJZrZw/pk=";
  };

  disabled = lua.luaversion != "5.1";
  propagatedBuildInputs = [ plenary-nvim ];

  meta = {
    homepage = "https://github.com/nvim-telescope/telescope.nvim";
    description = "Find, Filter, Preview, Pick. All lua, all the time.";
    license.fullName = "MIT";
  };
}) {};

tiktoken_core = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder, luarocks-build-rust-mlua }:
buildLuarocksPackage {
  pname = "tiktoken_core";
  version = "0.2.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/tiktoken_core-0.2.1-1.rockspec";
    sha256 = "0mdmrpg82vmk0cqiqdayyk4vvl299z0xqrg58q18dfs5nc27wkla";
  }).outPath;
  src = fetchFromGitHub {
    owner = "gptlang";
    repo = "lua-tiktoken";
    rev = "0.2.1";
    hash = "sha256-drSAVGHrdDdaWUEAfCE/2ZCI2nuffpbupO+TVWv/l4Y=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ luarocks-build-rust-mlua ];

  meta = {
    homepage = "https://github.com/gptlang/lua-tiktoken";
    description = "An experimental port of OpenAI's Tokenizer to lua";
    maintainers = with lib.maintainers; [ natsukium ];
    license.fullName = "MIT";
  };
}) {};

tl = callPackage({ argparse, buildLuarocksPackage, compat53, fetchFromGitHub, fetchurl, luafilesystem }:
buildLuarocksPackage {
  pname = "tl";
  version = "0.15.3-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/tl-0.15.3-1.rockspec";
    sha256 = "15p67r5bjp997pymjq80yn1gyf7r5g2nwkachkwx88100ihblqrc";
  }).outPath;
  src = fetchFromGitHub {
    owner = "teal-language";
    repo = "tl";
    rev = "v0.15.3";
    hash = "sha256-nkwPYI4uB1rTtcBsZ7TKNPusWXtXViyBDSkiL9UH+Wo=";
  };

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

toml-edit = callPackage({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder, luarocks-build-rust-mlua }:
buildLuarocksPackage {
  pname = "toml-edit";
  version = "0.3.6-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/toml-edit-0.3.6-1.rockspec";
    sha256 = "18fw256vzvfavfwrnzm507k4h3x2lx9l93ghr1ggsi4mhsnjki46";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/vhyrro/toml-edit.lua/archive/v0.3.6.zip";
    sha256 = "19v6axraj2n22lmilfr4x9nr40kcjb6wnpsfhf1mh2zy9nsd6ji6";
  };

  disabled = luaOlder "5.1";
  nativeBuildInputs = [ luarocks-build-rust-mlua ];

  meta = {
    homepage = "https://github.com/vhyrro/toml-edit.lua";
    description = "TOML Parser + Formatting and Comment-Preserving Editor";
    maintainers = with lib.maintainers; [ mrcjkb ];
    license.fullName = "MIT";
  };
}) {};

tree-sitter-norg = callPackage({ buildLuarocksPackage, fetchurl, fetchzip }:
buildLuarocksPackage {
  pname = "tree-sitter-norg";
  version = "0.2.4-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/tree-sitter-norg-0.2.4-1.rockspec";
    sha256 = "00mgn1kmhhrink64s1yjnz78lc7qbv0f021dsvr6z3b44srhcxb9";
  }).outPath;
  src = fetchzip {
    url    = "https://github.com/nvim-neorg/tree-sitter-norg/archive/v0.2.4.zip";
    sha256 = "08bsk3v61r0xhracanjv25jccqv80ahipx0mv5a1slzhcyymv8kd";
  };


  meta = {
    homepage = "https://github.com/nvim-neorg/tree-sitter-norg";
    description = "The official tree-sitter parser for Norg documents.";
    license.fullName = "MIT";
  };
}) {};

vstruct = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "vstruct";
  version = "2.1.1-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/vstruct-2.1.1-1.rockspec";
    sha256 = "111ff5207hspda9fpj9dqdd699rax0df3abdnfbmdbdy3j07dd04";
  }).outPath;
  src = fetchFromGitHub {
    owner = "ToxicFrog";
    repo = "vstruct";
    rev = "v2.1.1";
    hash = "sha256-p9yRJ3Kr6WQ4vBSTOVLoX6peNCJW6b6kgXCySg7aiWo=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/ToxicFrog/vstruct";
    description = "Lua library to manipulate binary data";
  };
}) {};

vusted = callPackage({ buildLuarocksPackage, busted, fetchFromGitHub, fetchurl, luasystem }:
buildLuarocksPackage {
  pname = "vusted";
  version = "2.3.4-1";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/vusted-2.3.4-1.rockspec";
    sha256 = "1yzdr0xgsjfr4a80a2zrj58ls0gmms407q4h1dx75sszppzvm1wc";
  }).outPath;
  src = fetchFromGitHub {
    owner = "notomo";
    repo = "vusted";
    rev = "v2.3.4";
    hash = "sha256-Zh54mHNrbFH5qygzsXVv+Vc7oUP+RIQXBvK+UvaGvxY=";
  };

  propagatedBuildInputs = [ busted luasystem ];

  meta = {
    homepage = "https://github.com/notomo/vusted";
    description = "`busted` wrapper for testing neovim plugin";
    maintainers = with lib.maintainers; [ figsoda ];
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
}) {};

xml2lua = callPackage({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
buildLuarocksPackage {
  pname = "xml2lua";
  version = "1.5-2";
  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/xml2lua-1.5-2.rockspec";
    sha256 = "1h0zszjzi65jc2rmpam7ai38sx2ph09q66jkik5mgzr6cxm1cm4h";
  }).outPath;
  src = fetchFromGitHub {
    owner = "manoelcampos";
    repo = "xml2lua";
    rev = "v1.5-2";
    hash = "sha256-hDCUTM+EM9Z+rCg+CbL6qLzY/5qaz6J1Q2khfBlkY+4=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "http://manoelcampos.github.io/xml2lua/";
    description = "An XML Parser written entirely in Lua that works for Lua 5.1+";
    maintainers = with lib.maintainers; [ teto ];
    license.fullName = "MIT";
  };
}) {};


}
/* GENERATED - do not edit this file */
