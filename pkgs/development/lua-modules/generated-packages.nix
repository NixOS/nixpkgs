/*
  pkgs/development/lua-modules/generated-packages.nix is an auto-generated file -- DO NOT EDIT!
  Regenerate it with: nix run nixpkgs#luarocks-packages-updater
  You can customize the generated packages in pkgs/development/lua-modules/overrides.nix
*/

{
  stdenv,
  lib,
  fetchurl,
  fetchgit,
  callPackage,
  ...
}:
final: prev: {
  alt-getopt = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "alt-getopt";
      version = "0.8.0-2";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/alt-getopt-0.8.0-2.rockspec";
          sha256 = "1x1wb351n8c9aghgrlwkjg4crriwby18drzrz3280mw9cildg11v";
        }).outPath;
      src = fetchFromGitHub {
        owner = "cheusov";
        repo = "lua-alt-getopt";
        rev = "0.8.0";
        hash = "sha256-OxtMNB8++cVQ/gQjntLUt3WYopGhYb1VbIUAZEzJB88=";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/cheusov/lua-alt-getopt";
        description = "Process application arguments the same way as getopt_long";
        maintainers = with lib.maintainers; [ arobyn ];
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  ansicolors = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "ansicolors";
      version = "1.0.2-3";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/ansicolors-1.0.2-3.rockspec";
          sha256 = "19y962xdx5ldl3596ywdl7n825dffz9al6j6rx6pbgmhb7pi8s5v";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/kikito/ansicolors.lua/archive/v1.0.2.tar.gz";
        sha256 = "0r4xi57njldmar9pn77l0vr5701rpmilrm51spv45lz0q9js8xps";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/kikito/ansicolors.lua";
        description = "Library for color Manipulation.";
        maintainers = with lib.maintainers; [ Freed-Wu ];
        license.fullName = "MIT <http://opensource.org/licenses/MIT>";
      };
    }
  ) { };

  argparse = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "argparse";
      version = "0.7.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/argparse-0.7.1-1.rockspec";
          sha256 = "116iaczq6glzzin6qqa2zn7i22hdyzzsq6mzjiqnz6x1qmi0hig8";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/luarocks/argparse/archive/0.7.1.zip";
        sha256 = "0idg79d0dfis4qhbkbjlmddq87np75hb2vj41i6prjpvqacvg5v1";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "https://github.com/luarocks/argparse";
        description = "A feature-rich command-line argument parser";
        license.fullName = "MIT";
      };
    }
  ) { };

  basexx = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "basexx";
      version = "0.4.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/basexx-0.4.1-1.rockspec";
          sha256 = "0kmydxm2wywl18cgj303apsx7hnfd68a9hx9yhq10fj7yfcxzv5f";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/aiq/basexx/archive/v0.4.1.tar.gz";
        sha256 = "1rnz6xixxqwy0q6y2hi14rfid4w47h69gfi0rnlq24fz8q2b0qpz";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/aiq/basexx";
        description = "A base2, base16, base32, base64 and base85 library for Lua";
        license.fullName = "MIT";
      };
    }
  ) { };

  binaryheap = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "binaryheap";
      version = "0.4-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/binaryheap-0.4-1.rockspec";
          sha256 = "1ah37lhskmrb26by5ygs7jblx7qnf6mphgw8kwhw0yacvmkcbql4";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/Tieske/binaryheap.lua/archive/version_0v4.tar.gz";
        sha256 = "0f5l4nb5s7dycbkgh3rrl7pf0npcf9k6m2gr2bsn09fjyb3bdc8h";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/Tieske/binaryheap.lua";
        description = "Binary heap implementation in pure Lua";
        maintainers = with lib.maintainers; [ vcunat ];
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  bit32 = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "bit32";
      version = "5.3.5.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/bit32-5.3.5.1-1.rockspec";
          sha256 = "11mg0hmmil92hkwamm91ghih6ys9pqsakx0z9jgnqxymnl887j51";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/keplerproject/lua-compat-5.3/archive/v0.10.zip";
        sha256 = "1caxn228gx48g6kymp9w7kczgxcg0v0cd5ixsx8viybzkd60dcn4";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "http://www.lua.org/manual/5.2/manual.html#6.7";
        description = "Lua 5.2 bit manipulation library";
        maintainers = with lib.maintainers; [ lblasc ];
        license.fullName = "MIT";
      };
    }
  ) { };

  busted = callPackage (
    {
      buildLuarocksPackage,
      dkjson,
      fetchFromGitHub,
      fetchurl,
      lua-term,
      luaOlder,
      lua_cliargs,
      luassert,
      luasystem,
      mediator_lua,
      penlight,
      say,
    }:
    buildLuarocksPackage {
      pname = "busted";
      version = "2.2.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/busted-2.2.0-1.rockspec";
          sha256 = "0h4zk4lcm40wg3l0vgjn6lsyh9yayhljx65a0pz5n99dxal8lgnf";
        }).outPath;
      src = fetchFromGitHub {
        owner = "lunarmodules";
        repo = "busted";
        rev = "v2.2.0";
        hash = "sha256-5LxPqmoUwR3XaIToKUgap0L/sNS9uOV080MIenyLnl8=";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        dkjson
        lua-term
        lua_cliargs
        luassert
        luasystem
        mediator_lua
        penlight
        say
      ];

      meta = {
        homepage = "https://lunarmodules.github.io/busted/";
        description = "Elegant Lua unit testing";
        license.fullName = "MIT <http://opensource.org/licenses/MIT>";
      };
    }
  ) { };

  busted-htest = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
    }:
    buildLuarocksPackage {
      pname = "busted-htest";
      version = "1.0.0-2";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/busted-htest-1.0.0-2.rockspec";
          sha256 = "10d2pbh2rfy4ygp40h8br4w5j1z5syq5pn6knd4bbnacmswnmcdl";
        }).outPath;
      src = fetchFromGitHub {
        owner = "hishamhm";
        repo = "busted-htest";
        rev = "1.0.0";
        hash = "sha256-tGAQUSeDt+OV/TBAJo/JFdyeBRRZaIQEJG+SKcCaQhs=";
      };

      meta = {
        homepage = "https://github.com/hishamhm/busted-htest";
        description = "A pretty output handler for Busted";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  cassowary = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
      penlight,
    }:
    buildLuarocksPackage {
      pname = "cassowary";
      version = "2.3.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/cassowary-2.3.2-1.rockspec";
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
    }
  ) { };

  cldr = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
      penlight,
    }:
    buildLuarocksPackage {
      pname = "cldr";
      version = "0.3.0-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/cldr-0.3.0-0.rockspec";
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
    }
  ) { };

  commons-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "commons.nvim";
      version = "27.0.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/commons.nvim-27.0.0-1.rockspec";
          sha256 = "0gz1943nrlpi7pq4izip6fb0pkfk13h5322qhynx27m82nm129mq";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/linrongbin16/commons.nvim/archive/ac18006fe9e47cf6e53c79e333465d5a75455357.zip";
        sha256 = "10qlgly499lyhvmhj5lqv4jqzyrlx6h7h7gjbyrgzpjqyjr99m1l";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://linrongbin16.github.io/commons.nvim/";
        description = "The commons lua library for Neovim plugin project.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  compat53 = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "compat53";
      version = "0.14.4-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/compat53-0.14.4-1.rockspec";
          sha256 = "01ahfb6g7ibxrlvypvrsry4pwzfj978afjfa9c5w1s7ahjf95d40";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/lunarmodules/lua-compat-5.3/archive/v0.14.4.zip";
        sha256 = "16mvf6qq290m8pla3fq3r6d6fmbbysjy8b5rxi40hchs4ngrn847";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "https://github.com/lunarmodules/lua-compat-5.3";
        description = "Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1";
        maintainers = with lib.maintainers; [ vcunat ];
        license.fullName = "MIT";
      };
    }
  ) { };

  cosmo = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      lpeg,
    }:
    buildLuarocksPackage {
      pname = "cosmo";
      version = "16.06.04-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/cosmo-16.06.04-1.rockspec";
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
    }
  ) { };

  coxpcall = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
    }:
    buildLuarocksPackage {
      pname = "coxpcall";
      version = "1.17.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/coxpcall-1.17.0-1.rockspec";
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
    }
  ) { };

  cqueues = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      lua,
    }:
    buildLuarocksPackage {
      pname = "cqueues";
      version = "20200726.52-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/cqueues-20200726.52-0.rockspec";
          sha256 = "0w2kq9w0wda56k02rjmvmzccz6bc3mn70s9v7npjadh85i5zlhhp";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/wahern/cqueues/archive/rel-20200726.tar.gz";
        sha256 = "0lhd02ag3r1sxr2hx847rdjkddm04l1vf5234v5cz9bd4kfjw4cy";
      };

      disabled = lua.luaversion != "5.2";

      meta = {
        homepage = "http://25thandclement.com/~william/projects/cqueues.html";
        description = "Continuation Queues: Embeddable asynchronous networking, threading, and notification framework for Lua on Unix.";
        maintainers = with lib.maintainers; [ vcunat ];
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  cyan = callPackage (
    {
      argparse,
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luafilesystem,
      luasystem,
      tl,
    }:
    buildLuarocksPackage {
      pname = "cyan";
      version = "0.4.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/cyan-0.4.1-1.rockspec";
          sha256 = "0m0br7fvczkaqx6zqj7ykmivw7fnizvi34cqp2mvzxn30hsa4hyw";
        }).outPath;
      src = fetchFromGitHub {
        owner = "teal-language";
        repo = "cyan";
        rev = "v0.4.1";
        hash = "sha256-jvBmOC1SMnuwgwtK6sPCDma+S5RyhItc6YjzMPULzSw=";
      };

      propagatedBuildInputs = [
        argparse
        luafilesystem
        luasystem
        tl
      ];

      meta = {
        homepage = "https://github.com/teal-language/cyan";
        description = "A build system for the Teal language";
        license.fullName = "MIT";
      };
    }
  ) { };

  datafile = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "datafile";
      version = "0.11-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/datafile-0.11-1.rockspec";
          sha256 = "09i0yqakzc342f2qqa0yxkdyz55y9s5v036x3xjwpfjry8yywc6q";
        }).outPath;
      src = fetchFromGitHub {
        owner = "hishamhm";
        repo = "datafile";
        rev = "v0.11";
        hash = "sha256-aHdxFJ2IB9v9UMK7vqk7tUA0rLmfvRd0nzhc9JO8AlQ=";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "http://github.com/hishamhm/datafile";
        description = "A library for handling paths when loading data files";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  digestif = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      lpeg,
      luaOlder,
      luafilesystem,
    }:
    buildLuarocksPackage {
      pname = "digestif";
      version = "0.6-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/digestif-0.6-1.rockspec";
          sha256 = "0hp7r97b6ivywaxb02cbnm23gjz71mak5ag6m3hi7f3mjqxxxh8k";
        }).outPath;
      src = fetchFromGitHub {
        owner = "astoff";
        repo = "digestif";
        rev = "v0.6";
        hash = "sha256-sGwKt9suRVNrbRJlhNMHzc5r4sK/fvUc7smxmxmrn8Y=";
      };

      disabled = luaOlder "5.3";
      propagatedBuildInputs = [
        lpeg
        luafilesystem
      ];

      meta = {
        homepage = "https://github.com/astoff/digestif/";
        description = "A code analyzer for TeX";
        license.fullName = "GPLv3+ and other free licenses";
      };
    }
  ) { };

  dkjson = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "dkjson";
      version = "2.8-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/dkjson-2.8-1.rockspec";
          hash = "sha256-arasJeX7yQ2Rg70RyepiGNvLdiyQz8Wn4HXrdTEIBBg=";
        }).outPath;
      src = fetchurl {
        url = "http://dkolf.de/dkjson-lua/dkjson-2.8.tar.gz";
        hash = "sha256-JOjNO+uRwchh63uz+8m9QYu/+a1KpdBHGBYlgjajFTI=";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "http://dkolf.de/dkjson-lua/";
        description = "David Kolf's JSON module for Lua";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  fennel = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "fennel";
      version = "1.6.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/fennel-1.6.0-1.rockspec";
          sha256 = "043nxxr69biy69avpmqx7dsingcpgq7zgihygfdb583aj0xfmry7";
        }).outPath;
      src = fetchFromGitHub {
        owner = "bakpakin";
        repo = "Fennel";
        rev = "1.6.0";
        hash = "sha256-WzsQwYgFU0Jm8YeaLCcJ0TbqNJao72TBxnigj7jw8yU=";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://fennel-lang.org";
        description = "A lisp that compiles to Lua";
        maintainers = with lib.maintainers; [ misterio77 ];
        license.fullName = "MIT";
      };
    }
  ) { };

  fidget-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "fidget.nvim";
      version = "1.6.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/fidget.nvim-1.6.0-1.rockspec";
          sha256 = "1jra7xv2ifsy5p3zwbiv70ynligjh8wx48ykmbi2cagd2vz9arwz";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/j-hui/fidget.nvim/archive/v1.6.0.zip";
        sha256 = "120q3dzq142xda1bzw8chf02k86dw21n8qjznlaxxpqlpk9sl6hr";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/j-hui/fidget.nvim";
        description = "Extensible UI for Neovim notifications and LSP progress messages.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  fifo = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
    }:
    buildLuarocksPackage {
      pname = "fifo";
      version = "0.2-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/fifo-0.2-0.rockspec";
          sha256 = "0vr9apmai2cyra2n573nr3dyk929gzcs4nm1096jdxcixmvh2ymq";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/daurnimator/fifo.lua/archive/0.2.zip";
        sha256 = "1800k7h5hxsvm05bjdr65djjml678lwb0661cll78z1ys2037nzn";
      };

      meta = {
        homepage = "https://github.com/daurnimator/fifo.lua";
        description = "A lua library/'class' that implements a FIFO";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  fluent = callPackage (
    {
      buildLuarocksPackage,
      cldr,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
      luaepnf,
      penlight,
    }:
    buildLuarocksPackage {
      pname = "fluent";
      version = "0.2.0-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/fluent-0.2.0-0.rockspec";
          sha256 = "1x3nk8xdf923rvdijr0jx8v6w3wxxfch7ri3kxca0pw80b5bc2fa";
        }).outPath;
      src = fetchFromGitHub {
        owner = "alerque";
        repo = "fluent-lua";
        rev = "v0.2.0";
        hash = "sha256-uDJWhQ/fDD9ZbYOgPk1FDlU3A3DAZw3Ujx92BglFWoo=";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        cldr
        luaepnf
        penlight
      ];

      meta = {
        homepage = "https://github.com/alerque/fluent-lua";
        description = "Lua implementation of Project Fluent";
        maintainers = with lib.maintainers; [ alerque ];
        license.fullName = "MIT";
      };
    }
  ) { };

  funnyfiles-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "funnyfiles.nvim";
      version = "1.0.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/funnyfiles.nvim-1.0.1-1.rockspec";
          sha256 = "1r3cgx8wvc1c4syk167m94ws513g0cdmmxnymf3zyidlszdwamy5";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/aikooo7/funnyfiles.nvim/archive/v1.0.1.zip";
        sha256 = "00p026r05gldbf18mmv8da9ap09di8dhy0rrd586pr2s2s36nzpd";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/aikooo7/funnyfiles.nvim";
        description = "This plugin is a way of creating/deleting files/folders without needing to open a file explorer.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  fzf-lua = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "fzf-lua";
      version = "0.0.2314-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/fzf-lua-0.0.2314-1.rockspec";
          sha256 = "1540vfygbgc55nd3kl19bkz3rwgg9b04mn3w76krppnl45aq59gg";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/ibhagwan/fzf-lua/archive/9a0704e8af8f8442110ff22a83b5608366b235df.zip";
        sha256 = "13ds1zl6hl8pllbs5ird4x87kjlj6g1i2zgzjdjkfzsdpc4fb4kd";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/ibhagwan/fzf-lua";
        description = "Improved fzf.vim written in lua";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "AGPL-3.0";
      };
    }
  ) { };

  fzy = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "fzy";
      version = "1.0.3-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/fzy-1.0.3-1.rockspec";
          sha256 = "07d07afjs73bl5krfbaqx4pw2wpfrkyw2iksamkfa8dlqn9ajn1a";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/swarn/fzy-lua/archive/v1.0.3.zip";
        sha256 = "0w3alddhn0jd19vmminbi1b79mzlagyl1lygmfpxhzzccdv4vapm";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/swarn/fzy-lua";
        description = "A lua implementation of the fzy fuzzy matching algorithm";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  gitsigns-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      lua,
    }:
    buildLuarocksPackage {
      pname = "gitsigns.nvim";
      version = "scm-1";

      src = fetchFromGitHub {
        owner = "lewis6991";
        repo = "gitsigns.nvim";
        rev = "5813e4878748805f1518cee7abb50fd7205a3a48";
        hash = "sha256-w3Q7nMFEbcjP6RmSTONg2Nw1dBXDEHnjQ69FuAPJRD8=";
      };

      disabled = lua.luaversion != "5.1";

      meta = {
        homepage = "https://github.com/lewis6991/gitsigns.nvim";
        description = "Git signs written in pure lua";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  grug-far-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "grug-far.nvim";
      version = "1.6.53-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/grug-far.nvim-1.6.53-1.rockspec";
          sha256 = "0wi4b1iv8clspp5nflmf7qfl56dwgclfzvh83wyp6zgp7i1s0rxm";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/MagicDuck/grug-far.nvim/archive/b58b2d65863f4ebad88b10a1ddd519e5380466e0.zip";
        sha256 = "06g8710k74ymwcm358y6h2c12v4n8wr95nhs2a0514xlqa3khadq";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/MagicDuck/grug-far.nvim";
        description = "Find And Replace plugin for neovim";
        maintainers = with lib.maintainers; [ teto ];
        license.fullName = "MIT";
      };
    }
  ) { };

  haskell-tools-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "haskell-tools.nvim";
      version = "6.2.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/haskell-tools.nvim-6.2.0-1.rockspec";
          sha256 = "0y7z59sf0pa1awj7vx3h4lfcmbkv2f933a5lmy9k7sa6zcmrdd7i";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/mrcjkb/haskell-tools.nvim/archive/v6.2.0.zip";
        sha256 = "123sa84kanmh80bqqqymziyzdr7gwag4m432iabbx9708qmx62c2";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/mrcjkb/haskell-tools.nvim";
        description = "🦥 Supercharge your Haskell experience in neovim!";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "GPL-2.0";
      };
    }
  ) { };

  http = callPackage (
    {
      basexx,
      binaryheap,
      bit32,
      buildLuarocksPackage,
      compat53,
      cqueues,
      fetchurl,
      fetchzip,
      fifo,
      lpeg,
      lpeg_patterns,
      luaOlder,
      luaossl,
    }:
    buildLuarocksPackage {
      pname = "http";
      version = "0.4-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/http-0.4-0.rockspec";
          sha256 = "0kbf7ybjyj6408sdrmh1jb0ig5klfc8mqcwz6gv6rd6ywn47qifq";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/daurnimator/lua-http/archive/v0.4.zip";
        sha256 = "0252mc3mns1ni98hhcgnb3pmb53lk6nzr0jgqin0ggcavyxycqb2";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        basexx
        binaryheap
        bit32
        compat53
        cqueues
        fifo
        lpeg
        lpeg_patterns
        luaossl
      ];

      meta = {
        homepage = "https://github.com/daurnimator/lua-http";
        description = "HTTP library for Lua";
        maintainers = with lib.maintainers; [ vcunat ];
        license.fullName = "MIT";
      };
    }
  ) { };

  image-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      magick,
    }:
    buildLuarocksPackage {
      pname = "image.nvim";
      version = "1.3.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/image.nvim-1.3.0-1.rockspec";
          sha256 = "1ls3v5xcgmqmscqk5prpj0q9sy0946rfb2dfva5f1axb5x4jbvj9";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/3rd/image.nvim/archive/v1.3.0.zip";
        sha256 = "0fbc3wvzsck8bbz8jz5piy68w1xmq5cnhaj1lw91d8hkyjryrznr";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ magick ];

      meta = {
        homepage = "https://github.com/3rd/image.nvim";
        description = "🖼️ Bringing images to Neovim.";
        maintainers = with lib.maintainers; [ teto ];
        license.fullName = "MIT";
      };
    }
  ) { };

  inspect = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "inspect";
      version = "3.1.3-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/inspect-3.1.3-0.rockspec";
          sha256 = "1iivb2jmz0pacmac2msyqwvjjx8q6py4h959m8fkigia6srg5ins";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/kikito/inspect.lua/archive/v3.1.3.tar.gz";
        sha256 = "1sqylz5hmj5sbv4gi9988j6av3cb5lwkd7wiyim1h5lr7xhnlf23";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/kikito/inspect.lua";
        description = "Lua table visualizer, ideal for debugging";
        license.fullName = "MIT <http://opensource.org/licenses/MIT>";
      };
    }
  ) { };

  jsregexp = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "jsregexp";
      version = "0.0.7-2";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/jsregexp-0.0.7-2.rockspec";
          sha256 = "048gaxgm45hvqz8x2sp3bjii2fgimwafccnwvf92crlj3r6cys6k";
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
    }
  ) { };

  ldbus = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "ldbus";
      version = "scm-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/ldbus-scm-0.rockspec";
          sha256 = "1c0h6fx7avzh89hl17v6simy1p4mjg8bimlsbjybks0zxznd8rbm";
        }).outPath;
      src = fetchFromGitHub {
        owner = "daurnimator";
        repo = "ldbus";
        rev = "5cc933bfad2b73674bc005ebcce771555a614792";
        hash = "sha256-MyldeKaqe7axZ423cKDE7+P2w26uRcjs0huuqlaVxQs=";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "https://github.com/daurnimator/ldbus";
        description = "A Lua library to access dbus.";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  ldoc = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      markdown,
      penlight,
    }:
    buildLuarocksPackage {
      pname = "ldoc";
      version = "1.5.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/ldoc-1.5.0-1.rockspec";
          sha256 = "1c0yx9j3yqlzxpmspz7n7l1nvh2sww84zhkb1fsbg042sr8h9bxp";
        }).outPath;
      src = fetchFromGitHub {
        owner = "lunarmodules";
        repo = "ldoc";
        rev = "v1.5.0";
        hash = "sha256-Me2LT+UzO8G2vHqG7DjjoCRAtLmhiJHlSEYQGkprxTw=";
      };

      propagatedBuildInputs = [
        markdown
        penlight
      ];

      meta = {
        homepage = "http://lunarmodules.github.io/ldoc";
        description = "A Lua Documentation Tool";
        license.fullName = "MIT <http://opensource.org/licenses/MIT>";
      };
    }
  ) { };

  lgi = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lgi";
      version = "0.9.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lgi-0.9.2-1.rockspec";
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
    }
  ) { };

  linenoise = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "linenoise";
      version = "0.9-1";

      src = fetchurl {
        url = "https://github.com/hoelzro/lua-linenoise/archive/0.9.tar.gz";
        sha256 = "177h6gbq89arwiwxah9943i8hl5gvd9wivnd1nhmdl7d8x0dn76c";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/hoelzro/lua-linenoise";
        description = "A binding for the linenoise command line library";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  ljsyscall = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      lua,
    }:
    buildLuarocksPackage {
      pname = "ljsyscall";
      version = "0.12-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/ljsyscall-0.12-1.rockspec";
          sha256 = "0zna5s852vn7q414z56kkyqwpighaghyq7h7in3myap4d9vcgm01";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/justincormack/ljsyscall/archive/v0.12.tar.gz";
        sha256 = "1w9g36nhxv92cypjia7igg1xpfrn3dbs3hfy6gnnz5mx14v50abf";
      };

      disabled = lua.luaversion != "5.1";

      meta = {
        homepage = "http://www.myriabit.com/ljsyscall/";
        description = "LuaJIT Linux syscall FFI";
        maintainers = with lib.maintainers; [ lblasc ];
        license.fullName = "MIT";
      };
    }
  ) { };

  llscheck = callPackage (
    {
      ansicolors,
      argparse,
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      lua-cjson,
      luaOlder,
      luafilesystem,
      penlight,
    }:
    buildLuarocksPackage {
      pname = "llscheck";
      version = "0.7.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/llscheck-0.7.0-1.rockspec";
          sha256 = "0mq44xjsgvdh50cyi5khjqm19xd1w8cjhrr6vbckmb0zpia2v9sk";
        }).outPath;
      src = fetchFromGitHub {
        owner = "jeffzi";
        repo = "llscheck";
        rev = "v0.7.0";
        hash = "sha256-DOXWBTw7ylfjrk6wxoii9/eAkY4WObtRStttQmhWglc=";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        ansicolors
        argparse
        lua-cjson
        luafilesystem
        penlight
      ];

      meta = {
        homepage = "https://github.com/jeffzi/llscheck";
        description = "Human-friendly Lua code analysis powered by Lua Language Server";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  lmathx = callPackage (
    { buildLuarocksPackage, fetchurl }:
    buildLuarocksPackage {
      pname = "lmathx";
      version = "20150624-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lmathx-20150624-1.rockspec";
          sha256 = "181wzsj1mxjyia43y8zwaydxahnl7a70qzcgc8jhhgic7jyi9pgv";
        }).outPath;
      src = fetchurl {
        url = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.3/lmathx.tar.gz";
        sha256 = "1r0ax3lq4xx6469aqc6qlfl3jynlghzhl5j65mpdj0kyzv4nknzf";
      };

      meta = {
        homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#lmathx";
        description = "C99 extensions for the math library";
        maintainers = with lib.maintainers; [ alexshpilkin ];
        license.fullName = "Public domain";
      };
    }
  ) { };

  lmpfrlib = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lmpfrlib";
      version = "20170112-2";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lmpfrlib-20170112-2.rockspec";
          sha256 = "1x7qiwmk5b9fi87fn7yvivdsis8h9fk9r3ipqiry5ahx72vzdm7d";
        }).outPath;
      src = fetchurl {
        url = "http://www.circuitwizard.de/lmpfrlib/lmpfrlib.c";
        sha256 = "1bkfwdacj1drzqsfxf352fjppqqwi5d4j084jr9vj9dvjb31rbc1";
      };

      disabled = luaOlder "5.3" || luaAtLeast "5.5";

      meta = {
        homepage = "http://www.circuitwizard.de/lmpfrlib/lmpfrlib.html";
        description = "Lua API for the GNU MPFR library";
        maintainers = with lib.maintainers; [ alexshpilkin ];
        license.fullName = "LGPL";
      };
    }
  ) { };

  loadkit = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "loadkit";
      version = "1.1.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/loadkit-1.1.0-1.rockspec";
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
    }
  ) { };

  lpeg = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lpeg";
      version = "1.1.0-2";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lpeg-1.1.0-2.rockspec";
          sha256 = "0g8bnsx1qkl8s1fglbdai9mznzyzf9mv5lcxjab47069b3d8caa4";
        }).outPath;
      src = fetchurl {
        url = "https://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.1.0.tar.gz";
        sha256 = "0aimsjpcpkh3kk65f0pg1z2bp6d83rn4dg6pgbx1yv14s9kms5ab";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://www.inf.puc-rio.br/~roberto/lpeg.html";
        description = "Parsing Expression Grammars For Lua";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  lpeg_patterns = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      lpeg,
    }:
    buildLuarocksPackage {
      pname = "lpeg_patterns";
      version = "0.5-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lpeg_patterns-0.5-0.rockspec";
          sha256 = "1vzl3ryryc624mchclzsfl3hsrprb9q214zbi1xsjcc4ckq5qfh7";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/daurnimator/lpeg_patterns/archive/v0.5.zip";
        sha256 = "1s3c179a64r45ffkawv9dnxw4mzwkzj00nr9z2gs5haajgpjivw6";
      };

      propagatedBuildInputs = [ lpeg ];

      meta = {
        homepage = "https://github.com/daurnimator/lpeg_patterns/archive/v0.5.zip";
        description = "a collection of LPEG patterns";
        license.fullName = "MIT";
      };
    }
  ) { };

  lpeglabel = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lpeglabel";
      version = "1.6.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lpeglabel-1.6.0-1.rockspec";
          sha256 = "13gc32pggng6f95xx5zw9n9ian518wlgb26mna9kh4q2xa1k42pm";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/sqmedeiros/lpeglabel/archive/v1.6.0-1.tar.gz";
        sha256 = "1i02lsxj20iygqm8fy6dih1gh21lqk5qj1mv14wlrkaywnv35wcv";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/sqmedeiros/lpeglabel/";
        description = "Parsing Expression Grammars For Lua with Labeled Failures";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  lrexlib-gnu = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lrexlib-gnu";
      version = "2.9.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lrexlib-gnu-2.9.2-1.rockspec";
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
    }
  ) { };

  lrexlib-oniguruma = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lrexlib-oniguruma";
      version = "2.9.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lrexlib-oniguruma-2.9.2-1.rockspec";
          sha256 = "13m2v6mmmlkf2bd1mnngg118s4ymrqs7n34la6hrb4m1x772adhd";
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
        description = "Regular expression library binding (oniguruma flavour).";
        maintainers = with lib.maintainers; [ junestepp ];
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  lrexlib-pcre = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lrexlib-pcre";
      version = "2.9.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lrexlib-pcre-2.9.2-1.rockspec";
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
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  lrexlib-posix = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lrexlib-posix";
      version = "2.9.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lrexlib-posix-2.9.2-1.rockspec";
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
    }
  ) { };

  lsp-progress-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lsp-progress.nvim";
      version = "1.0.15-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lsp-progress.nvim-1.0.15-1.rockspec";
          sha256 = "160l97hsq9574f1riq4kjwa66y39z2fgnjmnc7li1pf00dkh3fvq";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/linrongbin16/lsp-progress.nvim/archive/ae52979ad412371ea6dc39ff70c8dfc681fb42b8.zip";
        sha256 = "0c7s82fl5wamxykdlz63r0xclwdy9s658hp6zm5hmpgl3qyjdrir";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://linrongbin16.github.io/lsp-progress.nvim/";
        description = "A performant lsp progress status for Neovim.";
        maintainers = with lib.maintainers; [ gepbird ];
        license.fullName = "MIT";
      };
    }
  ) { };

  lua-cjson = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-cjson";
      version = "2.1.0.10-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-cjson-2.1.0.10-1.rockspec";
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
    }
  ) { };

  lua-cmsgpack = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-cmsgpack";
      version = "0.4.0-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-cmsgpack-0.4.0-0.rockspec";
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
        homepage = "https://github.com/antirez/lua-cmsgpack";
        description = "MessagePack C implementation and bindings for Lua 5.1/5.2/5.3";
        license.fullName = "Two-clause BSD";
      };
    }
  ) { };

  lua-curl = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-curl";
      version = "0.3.13-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-curl-0.3.13-1.rockspec";
          sha256 = "0lz534sm35hxazf1w71hagiyfplhsvzr94i6qyv5chjfabrgbhjn";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/Lua-cURL/Lua-cURLv3/archive/v0.3.13.zip";
        sha256 = "0gn59bwrnb2mvl8i0ycr6m3jmlgx86xlr9mwnc85zfhj7zhi5anp";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "https://github.com/Lua-cURL";
        description = "Lua binding to libcurl";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  lua-ffi-zlib = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-ffi-zlib";
      version = "0.6-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-ffi-zlib-0.6-0.rockspec";
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
    }
  ) { };

  lua-iconv = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-iconv";
      version = "7.0.0-4";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-iconv-7.0.0-4.rockspec";
          sha256 = "0j34zf98wdr6ks6snsrqi00vwm3ngsa5f74kadsn178iw7hd8c3q";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/lunarmodules/lua-iconv/archive/v7.0.0/lua-iconv-7.0.0.tar.gz";
        sha256 = "0arp0h342hpp4kfdxc69yxspziky4v7c13jbf12yrs8f1lnjzr0x";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/lunarmodules/lua-iconv/";
        description = "Lua binding to the iconv";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  lua-lsp = callPackage (
    {
      buildLuarocksPackage,
      dkjson,
      fetchFromGitHub,
      fetchurl,
      inspect,
      lpeglabel,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-lsp";
      version = "0.1.0-2";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-lsp-0.1.0-2.rockspec";
          sha256 = "19jsz00qlgbyims6cg8i40la7v8kr7zsxrrr3dg0kdg0i36xqs6c";
        }).outPath;
      src = fetchFromGitHub {
        owner = "Alloyed";
        repo = "lua-lsp";
        rev = "v0.1.0";
        hash = "sha256-Fy9d6ZS0R48dUpKpgJ9jRujQna5wsE3+StJ8GQyWY54=";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.4";
      propagatedBuildInputs = [
        dkjson
        inspect
        lpeglabel
      ];

      meta = {
        homepage = "https://github.com/Alloyed/lua-lsp";
        description = "A Language Server implementation for lua, the language";
        license.fullName = "MIT";
      };
    }
  ) { };

  lua-messagepack = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-messagepack";
      version = "0.5.4-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-messagepack-0.5.4-1.rockspec";
          sha256 = "1jygn6f8ab69z0nn1gib45wvjp075gzxp54vdmgxb3qfar0q70kr";
        }).outPath;
      src = fetchurl {
        url = "https://framagit.org/fperrad/lua-MessagePack/raw/releases/lua-messagepack-0.5.4.tar.gz";
        sha256 = "0kk1n9kf6wip8k2xx4wjlv7647biji2p86v4jf0h6d6wkaypq0kz";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://fperrad.frama.io/lua-MessagePack/";
        description = "a pure Lua implementation of the MessagePack serialization format";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  lua-protobuf = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-protobuf";
      version = "0.5.3-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-protobuf-0.5.3-1.rockspec";
          sha256 = "0jz3yxdf9n1zfnkywqjghn6nlfvkkv9li003kkzh7z0wzidqaljh";
        }).outPath;
      src = fetchFromGitHub {
        owner = "starwing";
        repo = "lua-protobuf";
        rev = "0.5.3";
        hash = "sha256-9vAv/Rhf9xrQnbd0nkaxGrcTRKkUSlpYRAJe2zpdIiY=";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/starwing/lua-protobuf";
        description = "protobuf data support for Lua";
        maintainers = with lib.maintainers; [ lockejan ];
        license.fullName = "MIT";
      };
    }
  ) { };

  lua-resty-http = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-resty-http";
      version = "0.17.2-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-resty-http-0.17.2-0.rockspec";
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
    }
  ) { };

  lua-resty-jwt = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      lua-resty-openssl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-resty-jwt";
      version = "0.2.3-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-resty-jwt-0.2.3-0.rockspec";
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
    }
  ) { };

  lua-resty-openidc = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      lua-resty-http,
      lua-resty-jwt,
      lua-resty-session,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-resty-openidc";
      version = "1.8.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-resty-openidc-1.8.0-1.rockspec";
          sha256 = "0jgajhn45nybhi7z15bg957kznzqcjzxc8nrzmgyignkwp4yi1qk";
        }).outPath;
      src = fetchFromGitHub {
        owner = "zmartzone";
        repo = "lua-resty-openidc";
        rev = "v1.8.0";
        hash = "sha256-LSkNWebMF1L1a66QszugAxcHsW5o9uxQZHWituFFgJs=";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        lua-resty-http
        lua-resty-jwt
        lua-resty-session
      ];

      meta = {
        homepage = "https://github.com/zmartzone/lua-resty-openidc";
        description = "A library for NGINX implementing the OpenID Connect Relying Party (RP) and the OAuth 2.0 Resource Server (RS) functionality";
        license.fullName = "Apache 2.0";
      };
    }
  ) { };

  lua-resty-openssl = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
    }:
    buildLuarocksPackage {
      pname = "lua-resty-openssl";
      version = "1.7.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-resty-openssl-1.7.0-1.rockspec";
          sha256 = "0p4i14ypbw39ap3dvxhfnnb221909z2lqlk16nbqx33brawydl64";
        }).outPath;
      src = fetchFromGitHub {
        owner = "fffonion";
        repo = "lua-resty-openssl";
        rev = "1.7.0";
        hash = "sha256-xcEnic0aQCgzIlgU/Z6dxH7WTyTK+g5UKo4BiKcvNxQ=";
      };

      meta = {
        homepage = "https://github.com/fffonion/lua-resty-openssl";
        description = "No summary";
        license.fullName = "BSD";
      };
    }
  ) { };

  lua-resty-session = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      lua-ffi-zlib,
      lua-resty-openssl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-resty-session";
      version = "4.1.5-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-resty-session-4.1.5-1.rockspec";
          sha256 = "1mapndwa260pk18v4nwnmz4bncqizfn1zc8k8aj1557pc1fj5ii6";
        }).outPath;
      src = fetchFromGitHub {
        owner = "bungle";
        repo = "lua-resty-session";
        rev = "v4.1.5";
        hash = "sha256-qwXNEWU0i3PUJK5cUChkcH43HnBCz4EEVPDQQ10Je+Q=";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        lua-ffi-zlib
        lua-resty-openssl
      ];

      meta = {
        homepage = "https://github.com/bungle/lua-resty-session";
        description = "Session Library for OpenResty - Flexible and Secure";
        license.fullName = "BSD";
      };
    }
  ) { };

  lua-rtoml = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      luaOlder,
      luarocks-build-rust-mlua,
    }:
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
      nativeBuildInputs = [ luarocks-build-rust-mlua ];
      propagatedBuildInputs = [ luarocks-build-rust-mlua ];

      meta = {
        homepage = "https://github.com/lblasc/lua-rtoml";
        description = "Lua bindings for the Rust toml crate.";
        maintainers = with lib.maintainers; [ lblasc ];
        license.fullName = "MIT";
      };
    }
  ) { };

  lua-subprocess = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      luaOlder,
    }:
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
    }
  ) { };

  lua-term = callPackage (
    { buildLuarocksPackage, fetchurl }:
    buildLuarocksPackage {
      pname = "lua-term";
      version = "0.8-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-term-0.8-1.rockspec";
          sha256 = "1728lj3x8shc5m1yczrl75szq15rnfpzk36n0m49181ly9wxn7s0";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/hoelzro/lua-term/archive/0.08.tar.gz";
        sha256 = "1vfdg5dzqdi3gn6wpc9a3djhsl6fn2ikqdwr8rrqrnd91qwlzycg";
      };

      meta = {
        homepage = "https://github.com/hoelzro/lua-term";
        description = "Terminal functions for Lua";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  lua-toml = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-toml";
      version = "2.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-toml-2.0-1.rockspec";
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
    }
  ) { };

  lua-utils-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-utils.nvim";
      version = "1.0.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-utils.nvim-1.0.2-1.rockspec";
          sha256 = "0s11j4vd26haz72rb0c5m5h953292rh8r62mvlxbss6i69v2dkr9";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorg/lua-utils.nvim/archive/v1.0.2.zip";
        sha256 = "0bnl2kvxs55l8cjhfpa834bm010n8r4gmsmivjcp548c076msagn";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/nvim-neorg/lua-utils.nvim";
        description = "A set of utility functions for Neovim plugins.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  lua-yajl = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-yajl";
      version = "2.1-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-yajl-2.1-0.rockspec";
          sha256 = "02jlgd4583p3q4w6hjgmdfkasxhamaj58byyrbmnch0qii61in9r";
        }).outPath;
      src = fetchFromGitHub {
        owner = "brimworks";
        repo = "lua-yajl";
        rev = "v2.1";
        hash = "sha256-zHBNedJkGEm47HpbeJvcm6JNUUfA1OunLHPJulR8rF8=";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/brimworks/lua-yajl";
        description = "Integrate the yajl JSON library with Lua.";
        maintainers = with lib.maintainers; [ pstn ];
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  lua-zlib = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua-zlib";
      version = "1.3-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua-zlib-1.3-0.rockspec";
          sha256 = "06mkh54k009bvn7xl8fbxl574n7zqk3ki04f0xbsc8an5w9bw1l8";
        }).outPath;
      src = fetchFromGitHub {
        owner = "brimworks";
        repo = "lua-zlib";
        rev = "v1.3";
        hash = "sha256-FjhI8i2yP4aeZGakFL+vuWKAdISTkdt1mPKl8GIecVM=";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/brimworks/lua-zlib";
        description = "Simple streaming interface to zlib for Lua.";
        maintainers = with lib.maintainers; [ koral ];
        license.fullName = "MIT";
      };
    }
  ) { };

  lua_cliargs = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lua_cliargs";
      version = "3.0.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lua_cliargs-3.0.2-1.rockspec";
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
    }
  ) { };

  luabitop = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      luaAtLeast,
      luaOlder,
    }:
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
    }
  ) { };

  luacheck = callPackage (
    {
      argparse,
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
      luafilesystem,
    }:
    buildLuarocksPackage {
      pname = "luacheck";
      version = "1.2.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luacheck-1.2.0-1.rockspec";
          sha256 = "0jnmrppq5hp8cwiw1daa33cdn8y2n5lsjk8vzn7ixb20ddz01m6c";
        }).outPath;
      src = fetchFromGitHub {
        owner = "lunarmodules";
        repo = "luacheck";
        rev = "v1.2.0";
        hash = "sha256-6aDXZRLq2c36dbasyVzcecQKoMvY81RIGYasdF211UY=";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        argparse
        luafilesystem
      ];

      meta = {
        homepage = "https://github.com/lunarmodules/luacheck";
        description = "A static analyzer and a linter for Lua";
        license.fullName = "MIT";
      };
    }
  ) { };

  luacov = callPackage (
    {
      buildLuarocksPackage,
      datafile,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luacov";
      version = "0.16.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luacov-0.16.0-1.rockspec";
          sha256 = "1yn056pd2x142lc1s2admnhjnv5hpqwlq6d5sr2ckj5g83x55dvx";
        }).outPath;
      src = fetchFromGitHub {
        owner = "lunarmodules";
        repo = "luacov";
        rev = "v0.16.0";
        hash = "sha256-GoJqiFyXH4chQ/k/qBPttnh/V4vUSfR2Lg8rt3CPKoY=";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ datafile ];

      meta = {
        homepage = "https://lunarmodules.github.io/luacov/";
        description = "Coverage analysis tool for Lua scripts";
        license.fullName = "MIT";
      };
    }
  ) { };

  luadbi = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luadbi";
      version = "0.7.4-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luadbi-0.7.4-1.rockspec";
          sha256 = "12nqbl2zmwyz7k0x1y5h235di3jb0xwf27p1rh8lcgg4cqx6izr7";
        }).outPath;
      src = fetchFromGitHub {
        owner = "mwild1";
        repo = "luadbi";
        rev = "v0.7.4";
        hash = "sha256-N4I8zVTodS01QUIncwAts/vxh2aFY2nYCnVmpN+2HwM=";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "https://github.com/mwild1/luadbi";
        description = "Database abstraction layer";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  luadbi-mysql = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaAtLeast,
      luaOlder,
      luadbi,
    }:
    buildLuarocksPackage {
      pname = "luadbi-mysql";
      version = "0.7.4-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luadbi-mysql-0.7.4-1.rockspec";
          sha256 = "0ngpml0mw272pp03kabl1q3jj4fd5hmdlgvw9a2hgl0051358i6c";
        }).outPath;
      src = fetchFromGitHub {
        owner = "mwild1";
        repo = "luadbi";
        rev = "v0.7.4";
        hash = "sha256-N4I8zVTodS01QUIncwAts/vxh2aFY2nYCnVmpN+2HwM=";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";
      propagatedBuildInputs = [ luadbi ];

      meta = {
        homepage = "https://github.com/mwild1/luadbi";
        description = "Database abstraction layer";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  luadbi-postgresql = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaAtLeast,
      luaOlder,
      luadbi,
    }:
    buildLuarocksPackage {
      pname = "luadbi-postgresql";
      version = "0.7.4-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luadbi-postgresql-0.7.4-1.rockspec";
          sha256 = "0wybfngdz8hw4sgmz8rmym1frz6fwrvpx1l5gh0j68m7q4l25crg";
        }).outPath;
      src = fetchFromGitHub {
        owner = "mwild1";
        repo = "luadbi";
        rev = "v0.7.4";
        hash = "sha256-N4I8zVTodS01QUIncwAts/vxh2aFY2nYCnVmpN+2HwM=";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";
      propagatedBuildInputs = [ luadbi ];

      meta = {
        homepage = "https://github.com/mwild1/luadbi";
        description = "Database abstraction layer";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  luadbi-sqlite3 = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaAtLeast,
      luaOlder,
      luadbi,
    }:
    buildLuarocksPackage {
      pname = "luadbi-sqlite3";
      version = "0.7.4-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luadbi-sqlite3-0.7.4-1.rockspec";
          sha256 = "05kjihy5a8hyhn286gi2q1qyyiy8ajnyqp90wv41zjvhxjhg8ymx";
        }).outPath;
      src = fetchFromGitHub {
        owner = "mwild1";
        repo = "luadbi";
        rev = "v0.7.4";
        hash = "sha256-N4I8zVTodS01QUIncwAts/vxh2aFY2nYCnVmpN+2HwM=";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";
      propagatedBuildInputs = [ luadbi ];

      meta = {
        homepage = "https://github.com/mwild1/luadbi";
        description = "Database abstraction layer";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  luaepnf = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      lpeg,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luaepnf";
      version = "0.3-2";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luaepnf-0.3-2.rockspec";
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
    }
  ) { };

  luaevent = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luaevent";
      version = "0.4.6-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luaevent-0.4.6-1.rockspec";
          sha256 = "03zixadhx4a7nh67n0sm6sy97c8i9va1a78hibhrl7cfbqc2zc7f";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/harningt/luaevent/archive/v0.4.6.tar.gz";
        sha256 = "0pbh315d3p7hxgzmbhphkcldxv2dadbka96131b8j5914nxvl4nx";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/harningt/luaevent";
        description = "libevent binding for Lua";
        license.fullName = "MIT";
      };
    }
  ) { };

  luaexpat = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luaexpat";
      version = "1.4.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luaexpat-1.4.1-1.rockspec";
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
        maintainers = with lib.maintainers; [
          arobyn
          flosse
        ];
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  luaffi = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luaffi";
      version = "scm-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luaffi-scm-1.rockspec";
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
    }
  ) { };

  luafilesystem = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luafilesystem";
      version = "1.8.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luafilesystem-1.8.0-1.rockspec";
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
    }
  ) { };

  lualdap = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lualdap";
      version = "1.4.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lualdap-1.4.0-1.rockspec";
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
    }
  ) { };

  lualine-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lualine.nvim";
      version = "scm-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lualine.nvim-scm-1.rockspec";
          sha256 = "01cqa4nvpq0z4230szwbcwqb0kd8cz2dycrd764r0z5c6vivgfzs";
        }).outPath;
      src = fetchFromGitHub {
        owner = "nvim-lualine";
        repo = "lualine.nvim";
        rev = "47f91c416daef12db467145e16bed5bbfe00add8";
        hash = "sha256-OpLZH+sL5cj2rcP5/T+jDOnuxd1QWLHCt2RzloffZOA=";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/nvim-lualine/lualine.nvim";
        description = "A blazing fast and easy to configure neovim statusline plugin written in pure lua.";
        license.fullName = "MIT";
      };
    }
  ) { };

  lualogging = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luasocket,
    }:
    buildLuarocksPackage {
      pname = "lualogging";
      version = "1.8.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lualogging-1.8.2-1.rockspec";
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
    }
  ) { };

  luaossl = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
    }:
    buildLuarocksPackage {
      pname = "luaossl";
      version = "20250929-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luaossl-20250929-0.rockspec";
          sha256 = "11m823vd8cwc3s5420lv042ny1d7hrimzx05ldy8f6rlh6m2d9xl";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/wahern/luaossl/archive/rel-20250929.zip";
        sha256 = "115a5r0n7qc9lnjxld551ag6l9rq1wawcbrfjqhz2l6krb3pbv3d";
      };

      meta = {
        homepage = "http://25thandclement.com/~william/projects/luaossl.html";
        description = "Most comprehensive OpenSSL module in the Lua universe.";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  luaposix = callPackage (
    {
      bit32,
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luaposix";
      version = "34.1.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luaposix-34.1.1-1.rockspec";
          sha256 = "0hx6my54axjcb3bklr991wji374qq6mwa3ily6dvb72vi2534nwz";
        }).outPath;
      src = fetchzip {
        url = "http://github.com/luaposix/luaposix/archive/v34.1.1.zip";
        sha256 = "0863r8c69yx92lalj174qdhavqmcs2cdimjim6k55qj9yn78v9zl";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.4";
      propagatedBuildInputs = [ bit32 ];

      meta = {
        homepage = "https://github.com/luaposix/luaposix/";
        description = "Lua bindings for POSIX";
        maintainers = with lib.maintainers; [ lblasc ];
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  luaprompt = callPackage (
    {
      argparse,
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luaprompt";
      version = "0.9-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luaprompt-0.9-1.rockspec";
          sha256 = "0bh4fpfrqbg9bappnrfr6blvl3lzc99plq7jac67mhph1bjki7rk";
        }).outPath;
      src = fetchFromGitHub {
        owner = "dpapavas";
        repo = "luaprompt";
        rev = "v0.9";
        hash = "sha256-S6bzlIY1KlMK3wy01wGuRujGFgPxcNWmCaISQ87EBGs=";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ argparse ];

      meta = {
        homepage = "https://github.com/dpapavas/luaprompt";
        description = "A Lua command prompt with pretty-printing and auto-completion";
        maintainers = with lib.maintainers; [ Freed-Wu ];
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  luarepl = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luarepl";
      version = "0.10-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luarepl-0.10-1.rockspec";
          sha256 = "12zdljfs4wg55mj7a38iwg7p5i1pmc934v9qlpi61sw4brp6x8d3";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/hoelzro/lua-repl/archive/0.10.tar.gz";
        sha256 = "0wv37h9w6y5pgr39m7yxbf8imkwvaila6rnwjcp0xsxl5c1rzfjm";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/hoelzro/lua-repl";
        description = "A reusable REPL component for Lua, written in Lua";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  luarocks = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
    }:
    buildLuarocksPackage {
      pname = "luarocks";
      version = "3.12.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luarocks-3.12.2-1.rockspec";
          sha256 = "1ak4w8hxl54yk2lj95l22xjrgw3cpla08s28aa160jrbk6vs5n44";
        }).outPath;
      src = fetchFromGitHub {
        owner = "luarocks";
        repo = "luarocks";
        rev = "v3.12.2";
        hash = "sha256-hQysstYGUcZnnEXL+9ECS0sBViYggeDIMgo6LpUexBA=";
      };

      meta = {
        homepage = "http://www.luarocks.org";
        description = "A package manager for Lua modules.";
        maintainers = with lib.maintainers; [
          mrcjkb
          teto
        ];
        license.fullName = "MIT";
      };
    }
  ) { };

  luarocks-build-rust-mlua = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
    }:
    buildLuarocksPackage {
      pname = "luarocks-build-rust-mlua";
      version = "0.2.5-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luarocks-build-rust-mlua-0.2.5-1.rockspec";
          sha256 = "0h5y2wjv6zpd44jsgv4aiiv5wjj0fls0c81m6wbgr7vl5sx10dnm";
        }).outPath;
      src = fetchFromGitHub {
        owner = "mlua-rs";
        repo = "luarocks-build-rust-mlua";
        rev = "0.2.5";
        hash = "sha256-OJk0UgM+GzuE7+AlpdTc3wcoelOk4tS3uOzjsZreBKs=";
      };

      meta = {
        homepage = "https://github.com/mlua-rs/luarocks-build-rust-mlua";
        description = "A LuaRocks build backend for Lua modules written in Rust using mlua";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  luarocks-build-treesitter-parser = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      luafilesystem,
    }:
    buildLuarocksPackage {
      pname = "luarocks-build-treesitter-parser";
      version = "6.0.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luarocks-build-treesitter-parser-6.0.1-1.rockspec";
          sha256 = "1sck7xjk0mpavq54n0qv0j08345mg5n6rhmi1p5kk77566kl8644";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorocks/luarocks-build-treesitter-parser/archive/v6.0.1.zip";
        sha256 = "1lagh03s6h7069p03g82r87xddpifhg5ifhahzrcmyafm564rwvm";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ luafilesystem ];

      meta = {
        homepage = "https://github.com/nvim-neorocks/luarocks-build-treesitter-parser";
        description = "A luarocks build backend for tree-sitter parsers.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  luarocks-build-treesitter-parser-cpp = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      luafilesystem,
    }:
    buildLuarocksPackage {
      pname = "luarocks-build-treesitter-parser-cpp";
      version = "2.0.5-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luarocks-build-treesitter-parser-cpp-2.0.5-1.rockspec";
          sha256 = "05hx146gmrn8c6ndgnqq521h66cd4lmpjkclvdlfpp5inck22cdd";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorocks/luarocks-build-treesitter-parser-cpp/archive/v2.0.5.zip";
        sha256 = "12q6kfnrw9cy0r8l3h79fnvfq5faapxgjmhf1xksb5kf077l0g7j";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ luafilesystem ];

      meta = {
        homepage = "https://github.com/nvim-neorocks/luarocks-build-treesitter-parser-cpp";
        description = "A luarocks build backend for tree-sitter parsers written in C++.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  luasec = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
      luasocket,
    }:
    buildLuarocksPackage {
      pname = "luasec";
      version = "1.3.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luasec-1.3.2-1.rockspec";
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
    }
  ) { };

  luasnip = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      jsregexp,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luasnip";
      version = "2.4.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luasnip-2.4.1-1.rockspec";
          sha256 = "03cl2qybqa06q41vxckamr46s7ij9igqz59ak0wshhzp7yysn2xr";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/L3MON4D3/LuaSnip/archive/v2.4.1.zip";
        sha256 = "1vjn0fwxv89p4dxycwn5lf7c0fgspzymbjp76n27rqnkab6v1qzy";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ jsregexp ];

      meta = {
        homepage = "https://github.com/L3MON4D3/LuaSnip";
        description = "Snippet Engine for Neovim written in Lua.";
        license.fullName = "Apache-2.0";
      };
    }
  ) { };

  luasocket = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luasocket";
      version = "3.1.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luasocket-3.1.0-1.rockspec";
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
    }
  ) { };

  luasql-sqlite3 = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luasql-sqlite3";
      version = "2.7.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luasql-sqlite3-2.7.0-1.rockspec";
          sha256 = "0fsx3r1hfdkvy07ki7rmmn23w0578mss8rfzz5fi668f0f35lywg";
        }).outPath;
      src = fetchFromGitHub {
        owner = "lunarmodules";
        repo = "luasql";
        rev = "2.7.0";
        hash = "sha256-vtL/ynlnZYNP3CQSxMR7o3xWx10rDHI9fIQazrtNfQE=";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://lunarmodules.github.io/luasql/";
        description = "Database connectivity for Lua (SQLite3 driver)";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  luassert = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
      say,
    }:
    buildLuarocksPackage {
      pname = "luassert";
      version = "1.9.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luassert-1.9.0-1.rockspec";
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
    }
  ) { };

  luasystem = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luasystem";
      version = "0.6.3-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luasystem-0.6.3-1.rockspec";
          sha256 = "0zqmrrnvpvy0bmvdc26lgcabx525xq0xy1ysh91d74hdvnznn2jc";
        }).outPath;
      src = fetchFromGitHub {
        owner = "lunarmodules";
        repo = "luasystem";
        rev = "v0.6.3";
        hash = "sha256-8d2835/EcyDJX9yTn6MTfaZryjY1wkSP+IIIKGPDXMk=";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/lunarmodules/luasystem";
        description = "Platform independent system calls for Lua.";
        license.fullName = "MIT <http://opensource.org/licenses/MIT>";
      };
    }
  ) { };

  luatext = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luatext";
      version = "1.2.1-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luatext-1.2.1-0.rockspec";
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
    }
  ) { };

  luaunbound = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luaunbound";
      version = "1.0.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luaunbound-1.0.0-1.rockspec";
          sha256 = "1zlkibdwrj5p97nhs33cz8xx0323z3kiq5x7v0h3i7v6j0h8ppvn";
        }).outPath;
      src = fetchurl {
        url = "https://code.zash.se/dl/luaunbound/luaunbound-1.0.0.tar.gz";
        sha256 = "1lsh0ylp5xskygxl5qdv6mhkm1x8xp0vfd5prk5hxkr19jk5mr3d";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "https://www.zash.se/luaunbound.html";
        description = "A binding to libunbound";
        license.fullName = "MIT";
      };
    }
  ) { };

  luaunit = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luaunit";
      version = "3.4-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luaunit-3.4-1.rockspec";
          sha256 = "111435fa8p2819vcvg76qmknj0wqk01gy9d1nh55c36616xnj54n";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/bluebird75/luaunit/releases/download/LUAUNIT_V3_4/rock-luaunit-3.4.zip";
        sha256 = "0qf07y3229lq3qq1mfkv83gzbc7dgyr67hysqjb5bbk333flv56r";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "https://github.com/bluebird75/luaunit";
        description = "A unit testing framework for Lua";
        maintainers = with lib.maintainers; [ lockejan ];
        license.fullName = "BSD";
      };
    }
  ) { };

  luautf8 = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luautf8";
      version = "0.2.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luautf8-0.2.0-1.rockspec";
          sha256 = "13lm2d7nc0igy739f3b9jrn4i4m373dqwkw41x0zzp0cm0v1c09m";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/starwing/luautf8/archive/refs/tags/0.2.0.tar.gz";
        sha256 = "0cmj4cp3sp3h2084qrix60vhrcg2xp56scn5qvsn8s5qjkci377p";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/starwing/luautf8";
        description = "A UTF-8 support module for Lua";
        maintainers = with lib.maintainers; [ pstn ];
        license.fullName = "MIT";
      };
    }
  ) { };

  luazip = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luazip";
      version = "1.2.7-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luazip-1.2.7-1.rockspec";
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
    }
  ) { };

  lusc_luv = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
      luv,
    }:
    buildLuarocksPackage {
      pname = "lusc_luv";
      version = "4.0.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lusc_luv-4.0.1-1.rockspec";
          sha256 = "1bgk481ljfy8q7r3w9z1x5ix0dm6v444c7mf9nahlpyrz9skxakp";
        }).outPath;
      src = fetchFromGitHub {
        owner = "svermeulen";
        repo = "lusc_luv";
        rev = "main";
        hash = "sha256-xT3so0QHtzzLRNRb7yqfaRMwkl2bt1MP1xh8BkHKqqo=";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ luv ];

      meta = {
        homepage = "https://github.com/svermeulen/lusc_luv";
        description = "Structured Async/Concurrency for Lua using Luv";
        license.fullName = "MIT";
      };
    }
  ) { };

  lush-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lush.nvim";
      version = "scm-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lush.nvim-scm-1.rockspec";
          sha256 = "0ivir5p3mmv051pyya2hj1yrnflrv8bp38dx033i3kzfbpyg23ca";
        }).outPath;
      src = fetchFromGitHub {
        owner = "rktjmp";
        repo = "lush.nvim";
        rev = "9c60ec2279d62487d942ce095e49006af28eed6e";
        hash = "sha256-ZDC2oirfDe/GqNx6+hivvNqdLutAxlBnSk51lf1yKqM=";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.4";

      meta = {
        homepage = "https://github.com/rktjmp/lush.nvim";
        description = "Define Neovim themes as a DSL in lua, with real-time feedback.";
        maintainers = with lib.maintainers; [ teto ];
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  luuid = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "luuid";
      version = "20120509-2";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/luuid-20120509-2.rockspec";
          sha256 = "1q2fv25wfbiqn49mqv26gs4pyllch311akcf7jjn27l5ik8ji5b6";
        }).outPath;
      src = fetchurl {
        url = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/5.2/luuid.tar.gz";
        sha256 = "1bfkj613d05yps3fivmz0j1bxf2zkg9g1yl0ifffgw0vy00hpnvm";
      };

      disabled = luaOlder "5.2" || luaAtLeast "5.4";

      meta = {
        homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#luuid";
        description = "A library for UUID generation";
        license.fullName = "Public domain";
      };
    }
  ) { };

  lyaml = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lyaml";
      version = "6.2.8-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lyaml-6.2.8-1.rockspec";
          sha256 = "0d0h70kjl5fkq589y1sx8qy8as002dhcf88pf60pghvch002ryi1";
        }).outPath;
      src = fetchzip {
        url = "http://github.com/gvvaughan/lyaml/archive/v6.2.8.zip";
        sha256 = "0r3jjsd8x2fs1aanki0s1mvpznl16f32c1qfgmicy0icgy5xfch0";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "http://github.com/gvvaughan/lyaml";
        description = "libYAML binding for Lua";
        maintainers = with lib.maintainers; [ lblasc ];
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  lz-n = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lz.n";
      version = "2.11.3-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lz.n-2.11.3-1.rockspec";
          sha256 = "0fg256gwa7444fh7wivasi77x7qgxx4r3hjqw90qa1kav10np88n";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorocks/lz.n/archive/v2.11.3.zip";
        sha256 = "0vnr1iiq4z3q7s3qylfmvcclmspydg8ll4p75jilcx9d114v7wwc";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/nvim-neorocks/lz.n";
        description = "🦥 A dead simple lazy-loading Lua library for Neovim plugins.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "GPL-2+";
      };
    }
  ) { };

  lze = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lze";
      version = "0.11.7-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lze-0.11.7-1.rockspec";
          sha256 = "18jj2g81i6b56a9kyg3q1qsrkgvhcz3kgcp419s4bvza8inkzqcq";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/BirdeeHub/lze/archive/v0.11.7.zip";
        sha256 = "0zr8pzib9xg8ngvlx536603ji99xwzgjcggxn7f6fl1b2zm4dj6n";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/BirdeeHub/lze";
        description = "A lazy-loading library for neovim, inspired by, but different from, nvim-neorocks/lz.n";
        maintainers = with lib.maintainers; [ birdee ];
        license.fullName = "GPL-2+";
      };
    }
  ) { };

  lzextras = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lzextras";
      version = "0.4.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lzextras-0.4.2-1.rockspec";
          sha256 = "1awxr7bmf5hfgvn5vjra1rdn57dcsmv9v33b5pgp13q6yjhr750s";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/BirdeeHub/lzextras/archive/v0.4.2.zip";
        sha256 = "1apgv3g9blwh25hqjhz1b7la3m2c3pfzalg42kg7y0x66ga78qf0";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/BirdeeHub/lzextras";
        description = "A collection of utilities and handlers for BirdeeHub/lze";
        maintainers = with lib.maintainers; [ birdee ];
        license.fullName = "GPL-2+";
      };
    }
  ) { };

  lzn-auto-require = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      lz-n,
    }:
    buildLuarocksPackage {
      pname = "lzn-auto-require";
      version = "0.2.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lzn-auto-require-0.2.0-1.rockspec";
          sha256 = "02w8pvyhnlbsz56rhgjql13qkh7fk05ai1qkqvk90a8ni8w48hh3";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/horriblename/lzn-auto-require/archive/v0.2.0.zip";
        sha256 = "1mgka1mmvpd2gfya898qdbbwrp5rpqds8manjs1s7g5x63xp6b98";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ lz-n ];

      meta = {
        homepage = "https://github.com/horriblename/lzn-auto-require";
        description = "Auto load optional plugins via lua modules with lz.n";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "GPL-2.0";
      };
    }
  ) { };

  magick = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      lua,
    }:
    buildLuarocksPackage {
      pname = "magick";
      version = "1.6.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/magick-1.6.0-1.rockspec";
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
    }
  ) { };

  markdown = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "markdown";
      version = "0.33-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/markdown-0.33-1.rockspec";
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
    }
  ) { };

  mediator_lua = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "mediator_lua";
      version = "1.1.2-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/mediator_lua-1.1.2-0.rockspec";
          sha256 = "0frzvf7i256260a1s8xh92crwa2m42972qxfq29zl05aw3pyn7bm";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/Olivine-Labs/mediator_lua/archive/v1.1.2-0.tar.gz";
        sha256 = "16zzzhiy3y35v8advmlkzpryzxv5vji7727vwkly86q8sagqbxgs";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "http://olivinelabs.com/mediator_lua/";
        description = "Event handling through channels";
        license.fullName = "MIT <http://opensource.org/licenses/MIT>";
      };
    }
  ) { };

  middleclass = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "middleclass";
      version = "4.1.1-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/middleclass-4.1.1-0.rockspec";
          sha256 = "10xzs48lr1dy7cx99581r956gl16px0a9gbdlfar41n19r96mhb1";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/kikito/middleclass/archive/v4.1.1.tar.gz";
        sha256 = "11ahv0b9wgqfnabv57rb7ilsvn2vcvxb1czq6faqrsqylvr5l7nh";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/kikito/middleclass";
        description = "A simple OOP library for Lua";
        license.fullName = "MIT";
      };
    }
  ) { };

  mimetypes = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "mimetypes";
      version = "1.1.0-2";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/mimetypes-1.1.0-2.rockspec";
          sha256 = "1asi5dlkqml9rjh2k2iq0fy2khdlc7mq4kxp4j42c8507w9dijww";
        }).outPath;
      src = fetchFromGitHub {
        owner = "lunarmodules";
        repo = "lua-mimetypes";
        rev = "v1.1.0";
        hash = "sha256-9uuhMerMqE/AtFFGNIWxGBN0BQ+FE+NgZa3g041lesE=";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/lunarmodules/lua-mimetypes";
        description = "A simple library for looking up the MIME types of files.";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  mini-test = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "mini.test";
      version = "0.16.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/mini.test-0.16.0-1.rockspec";
          sha256 = "0gw9cz6iy01c09gzhprrzlz12yz5pvivmjcxywajs1qq0095d5n1";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/echasnovski/mini.test/archive/v0.16.0.zip";
        sha256 = "0si92d4jc7lmzj2mppz0vcmgqgsbgy64fl4bj8jwdl7z78bhpjwk";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/echasnovski/mini.test";
        description = "Test neovim plugins. Part of the mini.nvim suite.";
        license.fullName = "MIT";
      };
    }
  ) { };

  moonscript = callPackage (
    {
      argparse,
      buildLuarocksPackage,
      fetchFromGitHub,
      lpeg,
      luaOlder,
      luafilesystem,
    }:
    buildLuarocksPackage {
      pname = "moonscript";
      version = "dev-1";

      src = fetchFromGitHub {
        owner = "leafo";
        repo = "moonscript";
        rev = "3b134e01ebc5961ca132bff5ba2871c88d65347e";
        hash = "sha256-ijWmxgoi524fbo3oXxuK/cPHxwHyGt3mMrGOw3+TsfY=";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        argparse
        lpeg
        luafilesystem
      ];

      meta = {
        homepage = "http://moonscript.org";
        description = "A programmer friendly language that compiles to Lua";
        maintainers = with lib.maintainers; [ arobyn ];
        license.fullName = "MIT";
      };
    }
  ) { };

  mpack = callPackage (
    { buildLuarocksPackage, fetchurl }:
    buildLuarocksPackage {
      pname = "mpack";
      version = "1.0.13-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/mpack-1.0.13-0.rockspec";
          sha256 = "1lyjbmyj6yfv0bhyj50rpz2qm993zsbyw494j9kz4bcvxx0gqac5";
        }).outPath;
      src = fetchurl {
        url = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.13/libmpack-lua-1.0.13.tar.gz";
        sha256 = "1mwk54jnayw5wjclijyha24xq4sj0lyidb04zyndd9i0yr4anlnx";
      };

      meta = {
        homepage = "https://github.com/libmpack/libmpack-lua";
        description = "Lua binding to libmpack";
        license.fullName = "MIT";
      };
    }
  ) { };

  neorg = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      lua-utils-nvim,
      luaOlder,
      nui-nvim,
      nvim-nio,
      pathlib-nvim,
      plenary-nvim,
    }:
    buildLuarocksPackage {
      pname = "neorg";
      version = "9.3.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/neorg-9.3.0-1.rockspec";
          sha256 = "14w4hbk2hhcg1va2lgvfzzfp67lprnfar56swl29ixnzlf82a9bi";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorg/neorg/archive/v9.3.0.zip";
        sha256 = "0ifl5n8sq8bafzx72ghfrmxsylhhlqvqmxzb5258jm76qj113cd9";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        lua-utils-nvim
        nui-nvim
        nvim-nio
        pathlib-nvim
        plenary-nvim
      ];

      meta = {
        homepage = "https://github.com/nvim-neorg/neorg";
        description = "Modernity meets insane extensibility. The future of organizing your life in Neovim.";
        maintainers = with lib.maintainers; [ GaetanLepage ];
        license.fullName = "GPL-3.0";
      };
    }
  ) { };

  neotest = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      nvim-nio,
      plenary-nvim,
    }:
    buildLuarocksPackage {
      pname = "neotest";
      version = "5.13.4-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/neotest-5.13.4-1.rockspec";
          sha256 = "0rv4m9qjpn6ckaqim49vy932765p9di4r563w684wz0ficdwjch3";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neotest/neotest/archive/deadfb1af5ce458742671ad3a013acb9a6b41178.zip";
        sha256 = "0qiff2cg7dz96mvfihgb9rgmg0zsjf95nvxnfnzw0pnp65ch4bnh";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        nvim-nio
        plenary-nvim
      ];

      meta = {
        homepage = "https://github.com/nvim-neotest/neotest";
        description = "An extensible framework for interacting with tests within NeoVim.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  nlua = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "nlua";
      version = "0.3.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/nlua-0.3.1-1.rockspec";
          sha256 = "1238vnwk14pdcq533a8ndmmkc0b9ndc4kh0aja7ypmsjvk2y5v3s";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/mfussenegger/nlua/archive/v0.3.1.zip";
        sha256 = "1m19ap9ipcdj16rbllxiqlww8hz98l63cdb8mhll37756nr773hn";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/mfussenegger/nlua";
        description = "Neovim as Lua interpreter";
        maintainers = with lib.maintainers; [ teto ];
        license.fullName = "GPL-3.0";
      };
    }
  ) { };

  nui-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
    }:
    buildLuarocksPackage {
      pname = "nui.nvim";
      version = "0.4.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/nui.nvim-0.4.0-1.rockspec";
          sha256 = "0bs87acbr7ih5ln9c5a394fsmg32afw9g3w5l9ji5hmxfbvj6prf";
        }).outPath;
      src = fetchFromGitHub {
        owner = "MunifTanjim";
        repo = "nui.nvim";
        rev = "0.4.0";
        hash = "sha256-SJc9nfV6cnBKYwRWsv0iHy+RbET8frNV85reICf+pt8=";
      };

      meta = {
        homepage = "https://github.com/MunifTanjim/nui.nvim";
        description = "UI Component Library for Neovim.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  nvim-cmp = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "nvim-cmp";
      version = "scm-1";

      src = fetchFromGitHub {
        owner = "hrsh7th";
        repo = "nvim-cmp";
        rev = "d97d85e01339f01b842e6ec1502f639b080cb0fc";
        hash = "sha256-Z6F8auKq1jSgGoPhV4RbkB1YTexnolSbEjpa/JJI/Fc=";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.4";

      meta = {
        homepage = "https://github.com/hrsh7th/nvim-cmp";
        description = "A completion plugin for neovim";
        license.fullName = "MIT";
      };
    }
  ) { };

  nvim-nio = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "nvim-nio";
      version = "1.10.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/nvim-nio-1.10.1-1.rockspec";
          sha256 = "1bkxvhk5bml6q5g4ycv3ggrqd24kkhhswa6if5g2q6j1j44lxgj0";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neotest/nvim-nio/archive/21f5324bfac14e22ba26553caf69ec76ae8a7662.zip";
        sha256 = "1bz5msxwk232zkkhfxcmr7a665la8pgkdx70q99ihl4x04jg6dkq";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/nvim-neotest/nvim-nio";
        description = "A library for asynchronous IO in Neovim";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  nvim-web-devicons = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "nvim-web-devicons";
      version = "0.100-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/nvim-web-devicons-0.100-1.rockspec";
          sha256 = "0i87kr2q1s97q4kw85k36xhryigbv4bgy3ig56qg6z5jgkxgldza";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-tree/nvim-web-devicons/archive/v0.100.zip";
        sha256 = "0d7gzk06f6z9wq496frbaavx90mcxvdhrswqd3pcayj2872i698d";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/nvim-tree/nvim-web-devicons";
        description = "Nerd Font icons for neovim";
        license.fullName = "MIT";
      };
    }
  ) { };

  oil-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      nvim-web-devicons,
    }:
    buildLuarocksPackage {
      pname = "oil.nvim";
      version = "2.15.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/oil.nvim-2.15.0-1.rockspec";
          sha256 = "0xkych23rn6jpj4hbam1j7ca1gwb9z3lzfm7id3dvcqj8aysv77j";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/stevearc/oil.nvim/archive/v2.15.0.zip";
        sha256 = "0rrv7wg0nwfj5fd6byxs4np1p18xxdzyv11ba6vqqh3s6z0qwawc";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ nvim-web-devicons ];

      meta = {
        homepage = "https://github.com/stevearc/oil.nvim";
        description = "Neovim file explorer: edit your filesystem like a buffer";
        license.fullName = "MIT";
      };
    }
  ) { };

  orgmode = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "orgmode";
      version = "0.7.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/orgmode-0.7.1-1.rockspec";
          sha256 = "19xdq0ym9136irbj2634g5flf067vwn8c10r5rzjyd6h8z0xqvg4";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-orgmode/orgmode/archive/0.7.1.zip";
        sha256 = "09hcmljhwfs14308hmaxajmcjhi9a0cl0bw1x1hsbrkbg37h99ka";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://nvim-orgmode.github.io";
        description = "Orgmode clone written in Lua for Neovim 0.11.0+.";
        license.fullName = "MIT";
      };
    }
  ) { };

  papis-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      nui-nvim,
      sqlite,
    }:
    buildLuarocksPackage {
      pname = "papis.nvim";
      version = "0.9.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/papis.nvim-0.9.1-1.rockspec";
          sha256 = "1ykcnzz2rpcn3v5aw4lhwc2vcc9gzrskkzir136i1szgnvrhhzg0";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/jghauser/papis.nvim/archive/v0.9.1.zip";
        sha256 = "1hicipx893p8y8sapn0kyqjinn8nhrrkc0a1cwl16z0mmh0jgk81";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        nui-nvim
        sqlite
      ];

      meta = {
        homepage = "https://github.com/jghauser/papis.nvim";
        description = "Manage your bibliography from within your favourite editor";
        maintainers = with lib.maintainers; [ GaetanLepage ];
        license.fullName = "GPL-3.0";
      };
    }
  ) { };

  pathlib-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      nvim-nio,
    }:
    buildLuarocksPackage {
      pname = "pathlib.nvim";
      version = "2.2.3-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/pathlib.nvim-2.2.3-1.rockspec";
          sha256 = "0qwsjcsl6760d8d5k1lxlykh78g6v7xcr9caq3yh75yn76mwrl4i";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/pysan3/pathlib.nvim/archive/v2.2.3.zip";
        sha256 = "1z3nwy83r3zbll9wc2wyvg60z0dqc5hm2xdfvqh3hwm5s9w8j432";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ nvim-nio ];

      meta = {
        homepage = "https://pysan3.github.io/pathlib.nvim/";
        description = "OS Independent, ultimate solution to path handling in neovim.";
        license.fullName = "MPL-2.0";
      };
    }
  ) { };

  penlight = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luafilesystem,
    }:
    buildLuarocksPackage {
      pname = "penlight";
      version = "1.14.0-3";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/penlight-1.14.0-3.rockspec";
          sha256 = "1qdc0x09wymlz7mikk660msaq5iv0yzds1z2rkyh4vmc1861gjgi";
        }).outPath;
      src = fetchFromGitHub {
        owner = "lunarmodules";
        repo = "penlight";
        rev = "1.14.0";
        hash = "sha256-4zAt0GgQEkg9toaUaDn3ST3RvjLUDsuOzrKi9lhq0fQ=";
      };

      propagatedBuildInputs = [ luafilesystem ];

      meta = {
        homepage = "https://lunarmodules.github.io/penlight";
        description = "Lua utility libraries loosely based on the Python standard libraries";
        maintainers = with lib.maintainers; [ alerque ];
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  plenary-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      luaAtLeast,
      luaOlder,
      luassert,
    }:
    buildLuarocksPackage {
      pname = "plenary.nvim";
      version = "scm-1";

      src = fetchFromGitHub {
        owner = "nvim-lua";
        repo = "plenary.nvim";
        rev = "b9fd5226c2f76c951fc8ed5923d85e4de065e509";
        hash = "sha256-9Un7ekhBxcnmFE1xjCCFTZ7eqIbmXvQexpnhduAg4M0=";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.4";
      propagatedBuildInputs = [ luassert ];

      meta = {
        homepage = "https://github.com/nvim-lua/plenary.nvim";
        description = "lua functions you don't want to write ";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  psl = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
    }:
    buildLuarocksPackage {
      pname = "psl";
      version = "0.3-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/psl-0.3-0.rockspec";
          sha256 = "1x7sc8n780k67v31bvqqxhh6ihy0k91zmp6xcxmkifr0gd008x9z";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/daurnimator/lua-psl/archive/v0.3.zip";
        sha256 = "1x9zskjn6fp9343w9314104128ik4lbk98pg6zfhl1v35107m1jx";
      };

      meta = {
        homepage = "https://github.com/daurnimator/lua-psl";
        description = "Bindings to libpsl, a C library that handles the Public Suffix List (PSL)";
        license.fullName = "MIT";
      };
    }
  ) { };

  rapidjson = callPackage (
    {
      buildLuarocksPackage,
      cmake,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "rapidjson";
      version = "0.7.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/rapidjson-0.7.2-1.rockspec";
          sha256 = "1g3gw1rr54jvylq7afzkqdpid3h7nlmk76hmfva8xzhcdvbcl88h";
        }).outPath;
      src = fetchFromGitHub {
        owner = "xpol";
        repo = "lua-rapidjson";
        rev = "v0.7.2";
        hash = "sha256-WdfGIgbwlMMItsasN+ZITd/iqSeHC0EVeYoUcolb1MU=";
      };

      disabled = luaOlder "5.1";
      nativeBuildInputs = [ cmake ];

      meta = {
        homepage = "https://github.com/xpol/lua-rapidjson";
        description = "Json module based on the very fast RapidJSON.";
        license.fullName = "MIT";
      };
    }
  ) { };

  rest-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      fidget-nvim,
      luaOlder,
      mimetypes,
      nvim-nio,
      tree-sitter-http,
      xml2lua,
    }:
    buildLuarocksPackage {
      pname = "rest.nvim";
      version = "3.13.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/rest.nvim-3.13.0-1.rockspec";
          sha256 = "1ig9589pb0y59jvlw97nxgcmij9kcjbc7l1aag99m40v823kncil";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/rest-nvim/rest.nvim/archive/v3.13.0.zip";
        sha256 = "18mmif73l13hbzhfvnvdky78jlv2j059cqyvxkb6bcqwcyqx7jaj";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        fidget-nvim
        mimetypes
        nvim-nio
        tree-sitter-http
        xml2lua
      ];

      meta = {
        homepage = "https://github.com/rest-nvim/rest.nvim";
        description = "A very fast, powerful, extensible and asynchronous Neovim HTTP client written in Lua.";
        maintainers = with lib.maintainers; [ teto ];
        license.fullName = "GPL-3.0";
      };
    }
  ) { };

  rocks-config-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      rocks-nvim,
    }:
    buildLuarocksPackage {
      pname = "rocks-config.nvim";
      version = "3.1.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/rocks-config.nvim-3.1.1-1.rockspec";
          sha256 = "1sg06ai9k2bkvcdm376lhbvc3n064bw237kcq579x703i7x3064b";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorocks/rocks-config.nvim/archive/v3.1.1.zip";
        sha256 = "00p02ghxfkzma7asvxq3m1mj9kvyg71w856v8pg78zv6db8fxcib";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ rocks-nvim ];

      meta = {
        homepage = "https://github.com/nvim-neorocks/rocks-config.nvim";
        description = "Allow rocks.nvim to help configure your plugins.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "GPL-3.0";
      };
    }
  ) { };

  rocks-dev-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      nvim-nio,
      rocks-nvim,
      rtp-nvim,
    }:
    buildLuarocksPackage {
      pname = "rocks-dev.nvim";
      version = "1.8.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/rocks-dev.nvim-1.8.0-1.rockspec";
          sha256 = "02ja27620fcw0wf516blz3130scwp96dz092di6w5lwj9dbfm9ab";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorocks/rocks-dev.nvim/archive/v1.8.0.zip";
        sha256 = "0hbdkry1xn8yqhicnzpqfy967s3bb61k87219pg4b3nmidd1pbym";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        nvim-nio
        rocks-nvim
        rtp-nvim
      ];

      meta = {
        homepage = "https://github.com/nvim-neorocks/rocks-dev.nvim";
        description = "A swiss-army knife for testing and developing rocks.nvim modules.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "GPL-3.0";
      };
    }
  ) { };

  rocks-git-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      nvim-nio,
      rocks-nvim,
    }:
    buildLuarocksPackage {
      pname = "rocks-git.nvim";
      version = "2.5.3-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/rocks-git.nvim-2.5.3-1.rockspec";
          sha256 = "0p69zdlh552r8grpbhx2h78hhc6d6cihc5dyanlxqfxr6kxw221m";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorocks/rocks-git.nvim/archive/v2.5.3.zip";
        sha256 = "0nm4yf3z2wmb7g10ij706vkwg9ss83ndp5wps3gfjr4zqdf85ayy";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        nvim-nio
        rocks-nvim
      ];

      meta = {
        homepage = "https://github.com/nvim-neorocks/rocks-git.nvim";
        description = "Use rocks.nvim to install plugins from git!";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "GPL-3.0";
      };
    }
  ) { };

  rocks-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      fidget-nvim,
      fzy,
      luaOlder,
      luarocks,
      nvim-nio,
      rtp-nvim,
      toml-edit,
    }:
    buildLuarocksPackage {
      pname = "rocks.nvim";
      version = "2.45.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/rocks.nvim-2.45.0-1.rockspec";
          sha256 = "18x579z30gj15njhpnvi1fff4q7c4s2mvsc9imrnyk9279gij8xb";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorocks/rocks.nvim/archive/v2.45.0.zip";
        sha256 = "10jawbwlm7d6im0k62y66ld023143d2qnqaybf2kimrr6wgqxq6d";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [
        fidget-nvim
        fzy
        luarocks
        nvim-nio
        rtp-nvim
        toml-edit
      ];

      meta = {
        homepage = "https://github.com/nvim-neorocks/rocks.nvim";
        description = "🌒 Neovim plugin management inspired by Cargo, powered by luarocks";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "GPL-3.0";
      };
    }
  ) { };

  rtp-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "rtp.nvim";
      version = "1.2.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/rtp.nvim-1.2.0-1.rockspec";
          sha256 = "0is9ssi3pwvshm88lnp4hkig4f0ckgl2f3a1axwci89y8lla50iv";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorocks/rtp.nvim/archive/v1.2.0.zip";
        sha256 = "1b6hx50nr2s2mnhsx9zy54pjdq7f78mi394v2b2c9v687s45nqln";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/nvim-neorocks/rtp.nvim";
        description = "Source plugin and ftdetect directories on the Neovim runtimepath.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "GPL-3.0";
      };
    }
  ) { };

  rustaceanvim = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "rustaceanvim";
      version = "6.9.7-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/rustaceanvim-6.9.7-1.rockspec";
          sha256 = "16vy2x8rbwxg3f9ff9qfklz8hcb6vzgg6apd1p63wd3piv6gl99w";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/mrcjkb/rustaceanvim/archive/v6.9.7.zip";
        sha256 = "12ah2vdhxxfaglylrw64dvgqsfzmp0smydz2npw76qqngklh9dlq";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://github.com/mrcjkb/rustaceanvim";
        description = "🦀 Supercharge your Rust experience in Neovim! A heavily modified fork of rust-tools.nvim";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "GPL-2.0";
      };
    }
  ) { };

  say = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "say";
      version = "1.4.1-3";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/say-1.4.1-3.rockspec";
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
    }
  ) { };

  serpent = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "serpent";
      version = "0.30-2";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/serpent-0.30-2.rockspec";
          sha256 = "0v83lr9ars1n0djbh7np8jjqdhhaw0pdy2nkcqzqrhv27rzv494n";
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
    }
  ) { };

  sofa = callPackage (
    {
      argparse,
      buildLuarocksPackage,
      compat53,
      fetchFromGitHub,
      fetchurl,
      luaAtLeast,
      luaOlder,
      luatext,
      lyaml,
    }:
    buildLuarocksPackage {
      pname = "sofa";
      version = "0.8.0-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/sofa-0.8.0-0.rockspec";
          sha256 = "09mjnygy8xpcp892mfqmcirjjndndvynl7bs7j4vp4r4svh17b05";
        }).outPath;
      src = fetchFromGitHub {
        owner = "f4z3r";
        repo = "sofa";
        rev = "v0.8.0";
        hash = "sha256-MWGp0kbLaXQV3ElSgPTFoVuWk4+ujktG0xh20kQPex4=";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";
      propagatedBuildInputs = [
        argparse
        compat53
        luatext
        lyaml
      ];

      meta = {
        homepage = "https://github.com/f4z3r/sofa";
        description = "A command execution engine powered by rofi.";
        maintainers = with lib.maintainers; [ f4z3r ];
        license.fullName = "MIT <http://opensource.org/licenses/MIT>";
      };
    }
  ) { };

  sqlite = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luv,
    }:
    buildLuarocksPackage {
      pname = "sqlite";
      version = "v1.2.2-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/sqlite-v1.2.2-0.rockspec";
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
    }
  ) { };

  std-_debug = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "std._debug";
      version = "1.0.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/std._debug-1.0.1-1.rockspec";
          sha256 = "0mr9hgzfr9v37da9rfys2wjq48hi3lv27i3g38433dlgbxipsbc4";
        }).outPath;
      src = fetchzip {
        url = "http://github.com/lua-stdlib/_debug/archive/v1.0.1.zip";
        sha256 = "19vfpv389q79vgxwhhr09l6l6hf6h2yjp09zvnp0l07ar4v660pv";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "http://lua-stdlib.github.io/_debug";
        description = "Debug Hints Library";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  std-normalize = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaAtLeast,
      luaOlder,
      std-_debug,
    }:
    buildLuarocksPackage {
      pname = "std.normalize";
      version = "2.0.3-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/std.normalize-2.0.3-1.rockspec";
          sha256 = "1l83ikiaw4dch2r69cxpl93b9d4wf54vbjb6fcggnkxxgm0amj3a";
        }).outPath;
      src = fetchzip {
        url = "http://github.com/lua-stdlib/normalize/archive/v2.0.3.zip";
        sha256 = "1gyywglxd2y7ck3hk8ap73w0x7hf9irpg6vgs8yc6k9k4c5g3fgi";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";
      propagatedBuildInputs = [ std-_debug ];

      meta = {
        homepage = "https://lua-stdlib.github.io/normalize";
        description = "Normalized Lua Functions";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  stdlib = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaAtLeast,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "stdlib";
      version = "41.2.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/stdlib-41.2.2-1.rockspec";
          sha256 = "0rscb4cm8s8bb8fk8rknc269y7bjqpslspsaxgs91i8bvabja6f6";
        }).outPath;
      src = fetchzip {
        url = "http://github.com/lua-stdlib/lua-stdlib/archive/release-v41.2.2.zip";
        sha256 = "0ry6k0wh4vyar1z68s0qmqzkdkfn9lcznsl8av7x78qz6l16wfw4";
      };

      disabled = luaOlder "5.1" || luaAtLeast "5.5";

      meta = {
        homepage = "http://lua-stdlib.github.io/lua-stdlib";
        description = "General Lua Libraries";
        license.fullName = "MIT/X11";
      };
    }
  ) { };

  teal-language-server = callPackage (
    {
      argparse,
      buildLuarocksPackage,
      dkjson,
      fetchFromGitHub,
      fetchurl,
      inspect,
      luafilesystem,
      lusc_luv,
      luv,
      tl,
    }:
    buildLuarocksPackage {
      pname = "teal-language-server";
      version = "0.0.5-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/teal-language-server-0.0.5-1.rockspec";
          sha256 = "11ps1hgkgli4sf9gcj7pin4kbc5w0yck0daig1ghqssn2q9m2x5l";
        }).outPath;
      src = fetchFromGitHub {
        owner = "teal-language";
        repo = "teal-language-server";
        rev = "main";
        hash = "sha256-TbNvYG2aRt27+sfXvZOlq/F7Gy6sQtoDz6satC+Qqss=";
      };

      propagatedBuildInputs = [
        argparse
        dkjson
        inspect
        luafilesystem
        lusc_luv
        luv
        tl
      ];

      meta = {
        homepage = "https://github.com/teal-language/teal-language-server";
        description = "A language server for the Teal language";
        license.fullName = "MIT";
      };
    }
  ) { };

  telescope-manix = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      telescope-nvim,
    }:
    buildLuarocksPackage {
      pname = "telescope-manix";
      version = "1.0.3-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/telescope-manix-1.0.3-1.rockspec";
          sha256 = "0avqlglmki244q3ffnlc358z3pn36ibcqysxrxw7h6qy1zcwm8sr";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/mrcjkb/telescope-manix/archive/1.0.3.zip";
        sha256 = "186rbdddpv8q0zcz18lnkarp0grdzxp80189n4zj2mqyzqnw0svj";
      };

      disabled = luaOlder "5.1";
      propagatedBuildInputs = [ telescope-nvim ];

      meta = {
        homepage = "https://github.com/mrcjkb/telescope-manix";
        description = "A telescope.nvim extension for Manix - A fast documentation searcher for Nix";
        license.fullName = "GPL-2.0";
      };
    }
  ) { };

  telescope-nvim = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      lua,
      plenary-nvim,
    }:
    buildLuarocksPackage {
      pname = "telescope.nvim";
      version = "scm-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/telescope.nvim-scm-1.rockspec";
          sha256 = "11dy6rkgkhc7zdrrvn361rwyf702yvvkhd0wz52pr757z534fk8s";
        }).outPath;
      src = fetchFromGitHub {
        owner = "nvim-telescope";
        repo = "telescope.nvim";
        rev = "f0caedf064aa8c926325d7fe64c141d29b8e7853";
        hash = "sha256-RrA84O25MlXvnATjgzpIehoYXH/h11vG0Zv8KR5uyIM=";
      };

      disabled = lua.luaversion != "5.1";
      propagatedBuildInputs = [ plenary-nvim ];

      meta = {
        homepage = "https://github.com/nvim-telescope/telescope.nvim";
        description = "Find, Filter, Preview, Pick. All lua, all the time.";
        license.fullName = "MIT";
      };
    }
  ) { };

  tiktoken_core = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
      luarocks-build-rust-mlua,
    }:
    buildLuarocksPackage {
      pname = "tiktoken_core";
      version = "0.2.5-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/tiktoken_core-0.2.5-1.rockspec";
          sha256 = "17bii1zxxkff0wwsgap4ni1k6ypbrbq5vfs7l34m0n78imx7c2l1";
        }).outPath;
      src = fetchFromGitHub {
        owner = "gptlang";
        repo = "lua-tiktoken";
        rev = "v0.2.5";
        hash = "sha256-V3dpFS590QkJQRIAeEgxakvoOGrilolWHutKn9zlOsg=";
      };

      disabled = luaOlder "5.1";
      nativeBuildInputs = [ luarocks-build-rust-mlua ];
      propagatedBuildInputs = [ luarocks-build-rust-mlua ];

      meta = {
        homepage = "https://github.com/gptlang/lua-tiktoken";
        description = "An experimental port of OpenAI's Tokenizer to lua";
        maintainers = with lib.maintainers; [ natsukium ];
        license.fullName = "MIT";
      };
    }
  ) { };

  tl = callPackage (
    {
      argparse,
      buildLuarocksPackage,
      compat53,
      fetchFromGitHub,
      fetchurl,
    }:
    buildLuarocksPackage {
      pname = "tl";
      version = "0.24.8-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/tl-0.24.8-1.rockspec";
          sha256 = "1m60ydmp6mn6iczg2an20ivvgn5rrz6sn0mhpnld9img3khvj7sf";
        }).outPath;
      src = fetchFromGitHub {
        owner = "teal-language";
        repo = "tl";
        rev = "v0.24.8";
        hash = "sha256-bjk/e+FuW0pSaVkRXIiYWhaNGU08Mgyvb7U7lc+8k2w=";
      };

      propagatedBuildInputs = [
        argparse
        compat53
      ];

      meta = {
        homepage = "https://github.com/teal-language/tl";
        description = "Teal, a typed dialect of Lua";
        maintainers = with lib.maintainers; [ mephistophiles ];
        license.fullName = "MIT";
      };
    }
  ) { };

  toml-edit = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      luarocks-build-rust-mlua,
    }:
    buildLuarocksPackage {
      pname = "toml-edit";
      version = "0.6.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/toml-edit-0.6.1-1.rockspec";
          sha256 = "0crvmigffka3n7583r1a7fgcjfq5b0819a7d155q50m52b7afc4z";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorocks/toml-edit.lua/archive/v0.6.1.zip";
        sha256 = "03gxfj2km4j08cx8yv70wvzwynnlwai6cdprrxnbf76mwy877hpg";
      };

      disabled = luaOlder "5.1";
      nativeBuildInputs = [ luarocks-build-rust-mlua ];

      meta = {
        homepage = "https://github.com/nvim-neorocks/toml-edit.lua";
        description = "TOML Parser + Formatting and Comment-Preserving Editor";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  tree-sitter-http = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luaOlder,
      luarocks-build-treesitter-parser,
    }:
    buildLuarocksPackage {
      pname = "tree-sitter-http";
      version = "0.0.33-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/tree-sitter-http-0.0.33-1.rockspec";
          sha256 = "1x6avlk3bdz406ywmxpq0sdi31fpfrbpqlbdz1ygh9gpknah5617";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/rest-nvim/tree-sitter-http/archive/d2e4e4c7d03f70e0465d436f2b5f67497cd544ca.zip";
        sha256 = "1wjycyvrahbpamdi6x74l8q1q8jrnk0y8nrwdwqdc7lm8hqjb5s2";
      };

      disabled = luaOlder "5.1";
      nativeBuildInputs = [ luarocks-build-treesitter-parser ];

      meta = {
        homepage = "https://github.com/rest-nvim/tree-sitter-http";
        description = "tree-sitter parser for http";
        license.fullName = "UNKNOWN";
      };
    }
  ) { };

  tree-sitter-norg = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luarocks-build-treesitter-parser-cpp,
    }:
    buildLuarocksPackage {
      pname = "tree-sitter-norg";
      version = "0.2.6-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/tree-sitter-norg-0.2.6-1.rockspec";
          sha256 = "1s0wj59v4zjgimws742ybzy7nhnnkz8nas4y5k96c2z5z54ynxmq";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-neorg/tree-sitter-norg/archive/v0.2.6.zip";
        sha256 = "077rds0rq10wjywpj4hmmq9dd6qp6sfwbdjyh587laldrfl7jy6g";
      };

      nativeBuildInputs = [ luarocks-build-treesitter-parser-cpp ];

      meta = {
        homepage = "https://github.com/nvim-neorg/tree-sitter-norg";
        description = "The official tree-sitter parser for Norg documents.";
        maintainers = with lib.maintainers; [ mrcjkb ];
        license.fullName = "MIT";
      };
    }
  ) { };

  tree-sitter-orgmode = callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      luarocks-build-treesitter-parser,
    }:
    buildLuarocksPackage {
      pname = "tree-sitter-orgmode";
      version = "2.0.2-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/tree-sitter-orgmode-2.0.2-1.rockspec";
          sha256 = "0ci1dgnvxxaf9vj2ipa6xcq80apl82yqr6a3r3a6wg2d88r0chkg";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/nvim-orgmode/tree-sitter-org/archive/2.0.2.zip";
        sha256 = "1rqw8malf09vxbmkinfjwhs490xjw41gvaydg590y30qvrqmaa5l";
      };

      nativeBuildInputs = [ luarocks-build-treesitter-parser ];

      meta = {
        homepage = "https://github.com/nvim-orgmode/tree-sitter-org";
        description = "A fork of tree-sitter-org, for use with the orgmode Neovim plugin";
        license.fullName = "MIT";
      };
    }
  ) { };

  vstruct = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "vstruct";
      version = "2.1.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/vstruct-2.1.1-1.rockspec";
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
    }
  ) { };

  vusted = callPackage (
    {
      buildLuarocksPackage,
      busted,
      fetchFromGitHub,
      fetchurl,
      luasystem,
    }:
    buildLuarocksPackage {
      pname = "vusted";
      version = "2.5.3-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/vusted-2.5.3-1.rockspec";
          sha256 = "1n0fpr3kw0dp9qiik8k9nh3jbckl4zs7kv7mjfffs9kms85jrq3d";
        }).outPath;
      src = fetchFromGitHub {
        owner = "notomo";
        repo = "vusted";
        rev = "v2.5.3";
        hash = "sha256-b07aSgDgSNpALs5en8ZXLEd/ThLEWX/dTME8Rg1K15I=";
      };

      propagatedBuildInputs = [
        busted
        luasystem
      ];

      meta = {
        homepage = "https://github.com/notomo/vusted";
        description = "`busted` wrapper for testing neovim plugin";
        license.fullName = "MIT <http://opensource.org/licenses/MIT>";
      };
    }
  ) { };

  xml2lua = callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "xml2lua";
      version = "1.6-2";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/xml2lua-1.6-2.rockspec";
          sha256 = "1fh57kv95a18q4869hmr4fbzbnlmq5z83mkkixvwzg3szf9kvfcn";
        }).outPath;
      src = fetchFromGitHub {
        owner = "manoelcampos";
        repo = "xml2lua";
        rev = "v1.6-2";
        hash = "sha256-4il5mmRLtuyCJ2Nm1tKv2hXk7rmiq7Fppx9LMbjkne0=";
      };

      disabled = luaOlder "5.1";

      meta = {
        homepage = "https://manoelcampos.github.io/xml2lua/";
        description = "An XML Parser written entirely in Lua that works for Lua 5.1+";
        maintainers = with lib.maintainers; [ teto ];
        license.fullName = "MIT";
      };
    }
  ) { };

}
# GENERATED - do not edit this file
