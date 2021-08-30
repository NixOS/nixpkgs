
/* pkgs/development/lua-modules/generated-packages.nix is an auto-generated file -- DO NOT EDIT!
Regenerate it with:
nixpkgs$ ./maintainers/scripts/update-luarocks-packages

You can customize the generated packages in pkgs/development/lua-modules/overrides.nix
*/

{ self, stdenv, lib, fetchurl, fetchgit, ... } @ args:
self: super:
with self;
{
alt-getopt = buildLuarocksPackage {
  pname = "alt-getopt";
  version = "0.8.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/alt-getopt-0.8.0-1.src.rock";
    sha256 = "1mi97dqb97sf47vb6wrk12yf1yxcaz0asr9gbgwyngr5n1adh5i3";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/cheusov/lua-alt-getopt";
    description = "Process application arguments the same way as getopt_long";
    maintainers = with lib.maintainers; [ arobyn ];
    license.fullName = "MIT/X11";
  };
};

ansicolors = buildLuarocksPackage {
  pname = "ansicolors";
  version = "1.0.2-3";

  src = fetchurl {
    url    = "https://github.com/kikito/ansicolors.lua/archive/v1.0.2.tar.gz";
    sha256 = "0r4xi57njldmar9pn77l0vr5701rpmilrm51spv45lz0q9js8xps";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/kikito/ansicolors.lua";
    description = "Library for color Manipulation.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
};

argparse = buildLuarocksPackage {
  pname = "argparse";
  version = "scm-2";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/luarocks/argparse.git",
  "rev": "27967d7b52295ea7885671af734332038c132837",
  "date": "2020-07-08T11:17:50+10:00",
  "path": "/nix/store/vjm6c826hgvj7h7vqlbgkfpvijsd8yaf-argparse",
  "sha256": "0idg79d0dfis4qhbkbjlmddq87np75hb2vj41i6prjpvqacvg5v1",
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
};

basexx = buildLuarocksPackage {
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
};

binaryheap = buildLuarocksPackage {
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
};

bit32 = buildLuarocksPackage {
  pname = "bit32";
  version = "5.3.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/bit32-5.3.0-1.src.rock";
    sha256 = "19i7kc2pfg9hc6qjq4kka43q6qk71bkl2rzvrjaks6283q6wfyzy";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.lua.org/manual/5.2/manual.html#6.7";
    description = "Lua 5.2 bit manipulation library";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT/X11";
  };
};

busted = buildLuarocksPackage {
  pname = "busted";
  version = "2.0.0-1";

  src = fetchurl {
    url    = "https://github.com/Olivine-Labs/busted/archive/v2.0.0.tar.gz";
    sha256 = "1ps7b3f4diawfj637mibznaw4x08gn567pyni0m2s50hrnw4v8zx";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua_cliargs luafilesystem luasystem dkjson say luassert lua-term penlight mediator_lua ];

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description = "Elegant Lua unit testing.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
};

cassowary = buildLuarocksPackage {
  pname = "cassowary";
  version = "2.3.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/cassowary-2.3.1-1.src.rock";
    sha256 = "1whb2d0isp2ca3nlli1kyql8ig9ny4wrvm309a1pzk8q9nys3pf9";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua penlight ];

  meta = {
    homepage = "https://github.com/sile-typesetter/cassowary.lua";
    description = "The cassowary constraint solver";
    maintainers = with lib.maintainers; [ marsam alerque ];
    license.fullName = "Apache 2";
  };
};

compat53 = buildLuarocksPackage {
  pname = "compat53";
  version = "0.7-1";

  src = fetchurl {
    url    = "https://luarocks.org/compat53-0.7-1.src.rock";
    sha256 = "0kpaxbpgrwjn4jjlb17fn29a09w6lw732d21bi0302kqcaixqpyb";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/keplerproject/lua-compat-5.3";
    description = "Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT";
  };
};

cosmo = buildLuarocksPackage {
  pname = "cosmo";
  version = "16.06.04-1";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/cosmo-16.06.04-1.src.rock";
    sha256 = "1adrk74j0x1yzhy0xz9k80hphxdjvm09kpwpbx00sk3kic6db0ww";
  };
  propagatedBuildInputs = [ lpeg ];

  meta = {
    homepage = "http://cosmo.luaforge.net";
    description = "Safe templates for Lua";
    maintainers = with lib.maintainers; [ marsam ];
    license.fullName = "MIT/X11";
  };
};

coxpcall = buildLuarocksPackage {
  pname = "coxpcall";
  version = "1.17.0-1";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/coxpcall-1.17.0-1.src.rock";
    sha256 = "0n1jmda4g7x06458596bamhzhcsly6x0p31yp6q3jz4j11zv1zhi";
  };

  meta = {
    homepage = "http://keplerproject.github.io/coxpcall";
    description = "Coroutine safe xpcall and pcall";
    license.fullName = "MIT/X11";
  };
};

cqueues = buildLuarocksPackage {
  pname = "cqueues";
  version = "20200726.52-0";

  src = fetchurl {
    url    = "https://luarocks.org/cqueues-20200726.52-0.src.rock";
    sha256 = "1mxs74gzs2xmgnrvhl1dlqy1m3m5m0wwiadack97r4pdd63dcp08";
  };
  disabled = (lua.luaversion != "5.2");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://25thandclement.com/~william/projects/cqueues.html";
    description = "Continuation Queues: Embeddable asynchronous networking, threading, and notification framework for Lua on Unix.";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT/X11";
  };
};

cyrussasl = buildLuarocksPackage {
  pname = "cyrussasl";
  version = "1.1.0-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/JorjBauer/lua-cyrussasl",
  "rev": "78ceec610da76d745d0eff4e21a4fb24832aa72d",
  "date": "2015-08-21T18:24:54-04:00",
  "path": "/nix/store/s7n7f80pz8k6lvfav55a5rwy5l45vs4l-lua-cyrussasl",
  "sha256": "14kzm3vk96k2i1m9f5zvpvq4pnzaf7s91h5g4h4x2bq1mynzw2s1",
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
};

digestif = buildLuarocksPackage {
  pname = "digestif";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/astoff/digestif",
  "rev": "3a9076f76d8121526adcdbb9303d04dd3c721a34",
  "date": "2021-06-24T16:18:41+02:00",
  "path": "/nix/store/alzrvcxdmdfqqmm0diaxfljyr3jz1zk3-digestif",
  "sha256": "110vsqyyp2pvn6nk492a9r56iyzymy0w1f2hvx26pv5x01mxm20x",
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.3");
  propagatedBuildInputs = [ lua lpeg ];

  meta = {
    homepage = "https://github.com/astoff/digestif/";
    description = "A code analyzer for TeX";
    license.fullName = "MIT";
  };
};

dkjson = buildLuarocksPackage {
  pname = "dkjson";
  version = "2.5-3";

  src = fetchurl {
    url    = "https://luarocks.org/dkjson-2.5-3.src.rock";
    sha256 = "0v5sihm85r0f458n1wvfjlmz59hjqlg5ndpp6dhd68fvrjikaw80";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://dkolf.de/src/dkjson-lua.fsl/";
    description = "David Kolf's JSON module for Lua";
    license.fullName = "MIT/X11";
  };
};

fifo = buildLuarocksPackage {
  pname = "fifo";
  version = "0.2-0";

  src = fetchurl {
    url    = "https://luarocks.org/fifo-0.2-0.src.rock";
    sha256 = "082c5g1m8brnsqj5gnjs65bm7z50l6b05cfwah14lqaqsr5a5pjk";
  };
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/daurnimator/fifo.lua";
    description = "A lua library/'class' that implements a FIFO";
    license.fullName = "MIT/X11";
  };
};

gitsigns-nvim = buildLuarocksPackage {
  pname = "gitsigns.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lewis6991/gitsigns.nvim",
  "rev": "daa233aabb4dbc7c870ea7300bcfeef96d49c2a3",
  "date": "2021-08-29T23:08:52+01:00",
  "path": "/nix/store/4685c871dzh0kqf3fs5iqmaysag4m9nx-gitsigns.nvim",
  "sha256": "0y0il8v0g8kvsyzir4hbkwvzv9wk2iqs1apxlvijk9ccfdk9ya0p",
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (lua.luaversion != "5.1");
  propagatedBuildInputs = [ lua plenary-nvim ];

  meta = {
    homepage = "http://github.com/lewis6991/gitsigns.nvim";
    description = "Git signs written in pure lua";
    license.fullName = "MIT/X11";
  };
};

http = buildLuarocksPackage {
  pname = "http";
  version = "0.3-0";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/http-0.3-0.src.rock";
    sha256 = "0vvl687bh3cvjjwbyp9cphqqccm3slv4g7y3h03scp3vpq9q4ccq";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua compat53 bit32 cqueues luaossl basexx lpeg lpeg_patterns binaryheap fifo ];

  meta = {
    homepage = "https://github.com/daurnimator/lua-http";
    description = "HTTP library for Lua";
    maintainers = with lib.maintainers; [ vcunat ];
    license.fullName = "MIT";
  };
};

inspect = buildLuarocksPackage {
  pname = "inspect";
  version = "3.1.1-0";

  src = fetchurl {
    url    = "https://luarocks.org/inspect-3.1.1-0.src.rock";
    sha256 = "0k4g9ahql83l4r2bykfs6sacf9l1wdpisav2i0z55fyfcdv387za";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/kikito/inspect.lua";
    description = "Lua table visualizer, ideal for debugging";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
};

ldbus = buildLuarocksPackage {
  pname = "ldbus";
  version = "scm-0";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/daurnimator/ldbus.git",
  "rev": "9e176fe851006037a643610e6d8f3a8e597d4073",
  "date": "2019-08-16T14:26:05+10:00",
  "path": "/nix/store/gg4zldd6kx048d6p65b9cimg3arma8yh-ldbus",
  "sha256": "06wcz4i5b7kphqbry274q3ivnsh331rxiyf7n4qk3zx2kvarq08s",
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/daurnimator/ldbus";
    description = "A Lua library to access dbus.";
    license.fullName = "MIT/X11";
  };
};

ldoc = buildLuarocksPackage {
  pname = "ldoc";
  version = "scm-3";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/stevedonovan/LDoc.git",
  "rev": "bbd498ab39fa49318b36378430d3cdab571f8ba0",
  "date": "2021-06-24T13:07:51+02:00",
  "path": "/nix/store/pzk1qi4fdviz2pq5bg3q91jmrg8wziqx-LDoc",
  "sha256": "05wd5m5v3gv777kgikj46216slxyf1zdbzl4idara9lcfw3mfyyw",
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
};

linenoise = buildLuarocksPackage {
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
};

ljsyscall = buildLuarocksPackage {
  pname = "ljsyscall";
  version = "0.12-1";

  src = fetchurl {
    url    = "https://luarocks.org/ljsyscall-0.12-1.src.rock";
    sha256 = "12gs81lnzpxi5d409lbrvjfflld5l2xsdkfhkz93xg7v65sfhh2j";
  };
  disabled = (lua.luaversion != "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.myriabit.com/ljsyscall/";
    description = "LuaJIT Linux syscall FFI";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT";
  };
};

lpeg = buildLuarocksPackage {
  pname = "lpeg";
  version = "1.0.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/lpeg-1.0.2-1.src.rock";
    sha256 = "1g5zmfh0x7drc6mg2n0vvlga2hdc08cyp3hnb22mh1kzi63xdl70";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.inf.puc-rio.br/~roberto/lpeg.html";
    description = "Parsing Expression Grammars For Lua";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
};

lpeg_patterns = buildLuarocksPackage {
  pname = "lpeg_patterns";
  version = "0.5-0";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lpeg_patterns-0.5-0.src.rock";
    sha256 = "0mlw4nayrsdxrh98i26avz5i4170a9brciybw88kks496ra36v8f";
  };
  propagatedBuildInputs = [ lua lpeg ];

  meta = {
    homepage = "https://github.com/daurnimator/lpeg_patterns/archive/v0.5.zip";
    description = "a collection of LPEG patterns";
    license.fullName = "MIT";
  };
};

lpeglabel = buildLuarocksPackage {
  pname = "lpeglabel";
  version = "1.6.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/lpeglabel-1.6.0-1.src.rock";
    sha256 = "0mihrs0gcj40gsjbh4x9b5pm92w2vdwwd1f3fyibyd4a8r1h93r9";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/sqmedeiros/lpeglabel/";
    description = "Parsing Expression Grammars For Lua with Labeled Failures";
    license.fullName = "MIT/X11";
  };
};

lpty = buildLuarocksPackage {
  pname = "lpty";
  version = "1.2.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/lpty-1.2.2-1.src.rock";
    sha256 = "1vxvsjgjfirl6ranz6k4q4y2dnxqh72bndbk400if22x8lqbkxzm";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.tset.de/lpty/";
    description = "A simple facility for lua to control other programs via PTYs.";
    license.fullName = "MIT";
  };
};

lrexlib-gnu = buildLuarocksPackage {
  pname = "lrexlib-gnu";
  version = "2.9.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/lrexlib-gnu-2.9.1-1.src.rock";
    sha256 = "07ppl5ib2q08mcy1nd4pixp58i0v0m9zv3y6ppbrzv105v21wdvi";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (GNU flavour).";
    license.fullName = "MIT/X11";
  };
};

lrexlib-pcre = buildLuarocksPackage {
  pname = "lrexlib-pcre";
  version = "2.9.1-1";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lrexlib-pcre-2.9.1-1.src.rock";
    sha256 = "0rsar13nax5r8f96pqjr0hf3civ1f1ijg4k7y69y5gi4wqd376lz";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (PCRE flavour).";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
};

lrexlib-posix = buildLuarocksPackage {
  pname = "lrexlib-posix";
  version = "2.9.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/lrexlib-posix-2.9.1-1.src.rock";
    sha256 = "0ajbzs3d6758f2hs95akirymw46nxcyy2prbzlaqq45ynzq02psb";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (POSIX flavour).";
    license.fullName = "MIT/X11";
  };
};

lua-cjson = buildLuarocksPackage {
  pname = "lua-cjson";
  version = "2.1.0.6-1";

  src = fetchurl {
    url    = "https://luarocks.org/lua-cjson-2.1.0.6-1.src.rock";
    sha256 = "0dqqkn0aygc780kiq2lbydb255r8is7raf7md0gxdjcagp8afps5";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.kyne.com.au/~mark/software/lua-cjson.php";
    description = "A fast JSON encoding/parsing module";
    license.fullName = "MIT";
  };
};

lua-cmsgpack = buildLuarocksPackage {
  pname = "lua-cmsgpack";
  version = "0.4.0-0";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/antirez/lua-cmsgpack.git",
  "rev": "57b1f90cf6cec46450e87289ed5a676165d31071",
  "date": "2018-06-14T11:56:56+02:00",
  "path": "/nix/store/ndjf00i9r45gvy8lh3vp218y4w4md33p-lua-cmsgpack",
  "sha256": "0yiwl4p1zh9qid3ksc4n9fv5bwaa9vjb0vgwnkars204xmxdj8fj",
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
};

lua-iconv = buildLuarocksPackage {
  pname = "lua-iconv";
  version = "7-3";

  src = fetchurl {
    url    = "https://luarocks.org/lua-iconv-7-3.src.rock";
    sha256 = "03xibhcqwihyjhxnzv367q4bfmzmffxl49lmjsq77g0prw8v0q83";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://ittner.github.com/lua-iconv/";
    description = "Lua binding to the iconv";
    license.fullName = "MIT/X11";
  };
};

lua-lsp = buildLuarocksPackage {
  pname = "lua-lsp";
  version = "0.1.0-2";

  src = fetchurl {
    url    = "https://luarocks.org/lua-lsp-0.1.0-2.src.rock";
    sha256 = "1cxj5qjdycx4vh411wb18kgglzcyarmm8495nw3yl5h2rx1pk3d3";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua dkjson lpeglabel inspect ];

  meta = {
    homepage = "https://github.com/Alloyed/lua-lsp";
    description = "A Language Server implementation for lua, the language";
    license.fullName = "MIT";
  };
};

lua-messagepack = buildLuarocksPackage {
  pname = "lua-messagepack";
  version = "0.5.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/lua-messagepack-0.5.2-1.src.rock";
    sha256 = "0hqahc84ncl8g4miif14sdkzyvnpqip48886sagz9drl52qvgcfb";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://fperrad.frama.io/lua-MessagePack/";
    description = "a pure Lua implementation of the MessagePack serialization format";
    license.fullName = "MIT/X11";
  };
};

lua-resty-http = buildLuarocksPackage {
  pname = "lua-resty-http";
  version = "0.16.1-0";

  src = fetchurl {
    url    = "https://luarocks.org/lua-resty-http-0.16.1-0.src.rock";
    sha256 = "0n5hiablpc0dsccs6h76zg81wc3jb4mdvyfn9lfxnhls3yqwrgkj";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/ledgetech/lua-resty-http";
    description = "Lua HTTP client cosocket driver for OpenResty / ngx_lua.";
    license.fullName = "2-clause BSD";
  };
};

lua-resty-jwt = buildLuarocksPackage {
  pname = "lua-resty-jwt";
  version = "0.2.3-0";

  src = fetchurl {
    url    = "https://luarocks.org/lua-resty-jwt-0.2.3-0.src.rock";
    sha256 = "0s7ghldwrjnhyc205pvcvgdzrgg46qz42v449vrri0cysh8ad91y";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua-resty-openssl ];

  meta = {
    homepage = "https://github.com/cdbattags/lua-resty-jwt";
    description = "JWT for ngx_lua and LuaJIT.";
    license.fullName = "Apache License Version 2";
  };
};

lua-resty-openidc = buildLuarocksPackage {
  pname = "lua-resty-openidc";
  version = "1.7.4-1";

  src = fetchurl {
    url    = "https://luarocks.org/lua-resty-openidc-1.7.4-1.src.rock";
    sha256 = "07ny9rl8zir1c3plrbdmd2a23ysrx45qam196nhqsz118xrbds78";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua-resty-http lua-resty-session lua-resty-jwt ];

  meta = {
    homepage = "https://github.com/zmartzone/lua-resty-openidc";
    description = "A library for NGINX implementing the OpenID Connect Relying Party (RP) and the OAuth 2.0 Resource Server (RS) functionality";
    license.fullName = "Apache 2.0";
  };
};

lua-resty-openssl = buildLuarocksPackage {
  pname = "lua-resty-openssl";
  version = "0.7.4-1";

  src = fetchurl {
    url    = "https://luarocks.org/lua-resty-openssl-0.7.4-1.src.rock";
    sha256 = "16rzcf6z9rgln4sc0v785awn2f3mi9yrswsk5xsfdsb2y1sdxdc0";
  };

  meta = {
    homepage = "https://github.com/fffonion/lua-resty-openssl";
    description = "No summary";
    license.fullName = "BSD";
  };
};

lua-resty-session = buildLuarocksPackage {
  pname = "lua-resty-session";
  version = "3.8-1";

  src = fetchurl {
    url    = "https://luarocks.org/lua-resty-session-3.8-1.src.rock";
    sha256 = "1x4l6n0dnm4br4p376r8nkg53hwm6a48xkhrzhsh9fcd5xqgqvxz";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/bungle/lua-resty-session";
    description = "Session Library for OpenResty – Flexible and Secure";
    license.fullName = "BSD";
  };
};

lua-term = buildLuarocksPackage {
  pname = "lua-term";
  version = "0.7-1";

  src = fetchurl {
    url    = "https://github.com/hoelzro/lua-term/archive/0.07.tar.gz";
    sha256 = "0c3zc0cl3a5pbdn056vnlan16g0wimv0p9bq52h7w507f72x18f1";
  };


  meta = {
    homepage = "https://github.com/hoelzro/lua-term";
    description = "Terminal functions for Lua";
    license.fullName = "MIT/X11";
  };
};

lua-toml = buildLuarocksPackage {
  pname = "lua-toml";
  version = "2.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/lua-toml-2.0-1.src.rock";
    sha256 = "0lyqlnydqbplq82brw9ipqy9gijin6hj1wc46plz994pg4i2c74m";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/jonstoler/lua-toml";
    description = "toml decoder/encoder for Lua";
    license.fullName = "MIT";
  };
};

lua-yajl = buildLuarocksPackage {
  pname = "lua-yajl";
  version = "2.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/lua-yajl-2.0-1.src.rock";
    sha256 = "0bsm519vs53rchcdf8g96ygzdx2bz6pa4vffqlvc7ap49bg5np4f";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/brimworks/lua-yajl";
    description = "Integrate the yajl JSON library with Lua.";
    maintainers = with lib.maintainers; [ pstn ];
    license.fullName = "MIT/X11";
  };
};

lua-zlib = buildLuarocksPackage {
  pname = "lua-zlib";
  version = "1.2-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/brimworks/lua-zlib.git",
  "rev": "82d0fdfe8ddd8645970f55011c13d87469501615",
  "date": "2021-03-08T06:04:09-08:00",
  "path": "/nix/store/2wr6l2djjl2l63wq1fddfm9ljrrkplr5-lua-zlib",
  "sha256": "18q9a5f21fp8hxvpp4sq23wi7m2h0v3p3kydslz140mnryazridj",
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/brimworks/lua-zlib";
    description = "Simple streaming interface to zlib for Lua.";
    maintainers = with lib.maintainers; [ koral ];
    license.fullName = "MIT";
  };
};

lua_cliargs = buildLuarocksPackage {
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
};

luabitop = buildLuarocksPackage {
  pname = "luabitop";
  version = "1.0.2-3";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/teto/luabitop.git",
  "rev": "8d7b674386460ca83e9510b3a8a4481344eb90ad",
  "date": "2021-08-30T10:14:03+02:00",
  "path": "/nix/store/sdnza0zpmlkz9jppnysasbvqy29f4zia-luabitop",
  "sha256": "1b57f99lrjbwsi4m23cq5kpj0dbpxh3xwr0mxs2rzykr2ijpgwrw",
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
};

luacheck = buildLuarocksPackage {
  pname = "luacheck";
  version = "0.24.0-2";

  src = fetchurl {
    url    = "https://luarocks.org/luacheck-0.24.0-2.src.rock";
    sha256 = "0in09mnhcbm84ia22qawn9mmfmaj0z6zqyii8xwz3llacss0mssq";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua argparse luafilesystem ];

  meta = {
    homepage = "https://github.com/luarocks/luacheck";
    description = "A static analyzer and a linter for Lua";
    license.fullName = "MIT";
  };
};

luacov = buildLuarocksPackage {
  pname = "luacov";
  version = "0.15.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/luacov-0.15.0-1.src.rock";
    sha256 = "14y79p62m1l7jwj8ay0b8nkarr6hdarjycr6qfzlc4v676h38ikq";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://keplerproject.github.io/luacov/";
    description = "Coverage analysis tool for Lua scripts";
    license.fullName = "MIT";
  };
};

luadbi = buildLuarocksPackage {
  pname = "luadbi";
  version = "0.7.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/luadbi-0.7.2-1.src.rock";
    sha256 = "0mj9ggyb05l03gs38ds508620mqaw4fkrzz9861n4j0zxbsbmfwy";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
};

luadbi-mysql = buildLuarocksPackage {
  pname = "luadbi-mysql";
  version = "0.7.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/luadbi-mysql-0.7.2-1.src.rock";
    sha256 = "1f8i5p66halws8qsa7g09110hwzg7pv29yi22mkqd8sjgjv42iq4";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
};

luadbi-postgresql = buildLuarocksPackage {
  pname = "luadbi-postgresql";
  version = "0.7.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/luadbi-postgresql-0.7.2-1.src.rock";
    sha256 = "0nmm1hdzl77wk8p6r6al6mpkh2n332a8r3iqsdi6v4nxamykdh28";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
};

luadbi-sqlite3 = buildLuarocksPackage {
  pname = "luadbi-sqlite3";
  version = "0.7.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/luadbi-sqlite3-0.7.2-1.src.rock";
    sha256 = "17wd2djzk5x4l4pv2k3c7b8dcvl46s96kqyk8dp3q6ll8gdl7c65";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license.fullName = "MIT/X11";
  };
};

luadoc = buildLuarocksPackage {
  pname = "luadoc";
  version = "3.0.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/luadoc-3.0.1-1.src.rock";
    sha256 = "112zqjbzkrhx3nvavrxx3vhpv2ix85pznzzbpa8fq4piyv5r781i";
  };
  propagatedBuildInputs = [ lualogging luafilesystem ];

  meta = {
    homepage = "http://luadoc.luaforge.net/";
    description = "LuaDoc is a documentation tool for Lua source code";
    license.fullName = "MIT/X11";
  };
};

luaepnf = buildLuarocksPackage {
  pname = "luaepnf";
  version = "0.3-2";

  src = fetchurl {
    url    = "https://luarocks.org/luaepnf-0.3-2.src.rock";
    sha256 = "01vghy965hkmycbvffb1rbgy16fp74103r2ihy3q78dzia4fbfvs";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua lpeg ];

  meta = {
    homepage = "http://siffiejoe.github.io/lua-luaepnf/";
    description = "Extended PEG Notation Format (easy grammars for LPeg)";
    license.fullName = "MIT";
  };
};

luaevent = buildLuarocksPackage {
  pname = "luaevent";
  version = "0.4.6-1";

  src = fetchurl {
    url    = "https://luarocks.org/luaevent-0.4.6-1.src.rock";
    sha256 = "0chq09nawiz00lxd6pkdqcb8v426gdifjw6js3ql0lx5vqdkb6dz";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/harningt/luaevent";
    description = "libevent binding for Lua";
    license.fullName = "MIT";
  };
};

luaexpat = buildLuarocksPackage {
  pname = "luaexpat";
  version = "1.3.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/luaexpat-1.3.0-1.src.rock";
    sha256 = "15jqz5q12i9zvjyagzwz2lrpzya64mih8v1hxwr0wl2gsjh86y5a";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.keplerproject.org/luaexpat/";
    description = "XML Expat parsing";
    maintainers = with lib.maintainers; [ arobyn flosse ];
    license.fullName = "MIT/X11";
  };
};

luaffi = buildLuarocksPackage {
  pname = "luaffi";
  version = "scm-1";

  src = fetchurl {
    url    = "mirror://luarocks/luaffi-scm-1.src.rock";
    sha256 = "0dia66w8sgzw26bwy36gzyb2hyv7kh9n95lh5dl0158rqa6fsf26";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/facebook/luaffifb";
    description = "FFI library for calling C functions from lua";
    license.fullName = "BSD";
  };
};

luafilesystem = buildLuarocksPackage {
  pname = "luafilesystem";
  version = "1.7.0-2";

  src = fetchurl {
    url    = "https://luarocks.org/luafilesystem-1.7.0-2.src.rock";
    sha256 = "0xhmd08zklsgpnpjr9rjipah35fbs8jd4v4va36xd8bpwlvx9rk5";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "git://github.com/keplerproject/luafilesystem";
    description = "File System Library for the Lua Programming Language";
    maintainers = with lib.maintainers; [ flosse ];
    license.fullName = "MIT/X11";
  };
};

lualogging = buildLuarocksPackage {
  pname = "lualogging";
  version = "1.5.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/lualogging-1.5.2-1.src.rock";
    sha256 = "1rxandfjff8z1jnryq9vcvhnva7qyrl7zjrc1mihg6fbddzdcfg7";
  };
  propagatedBuildInputs = [ luasocket ];

  meta = {
    homepage = "https://github.com/lunarmodules/lualogging";
    description = "A simple API to use logging features";
    license.fullName = "MIT/X11";
  };
};

luaossl = buildLuarocksPackage {
  pname = "luaossl";
  version = "20200709-0";

  src = fetchurl {
    url    = "https://luarocks.org/luaossl-20200709-0.src.rock";
    sha256 = "0y6dqf560j2bq2rjlm5572m82pj627fd2p9mjc5y6fbram764vga";
  };
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://25thandclement.com/~william/projects/luaossl.html";
    description = "Most comprehensive OpenSSL module in the Lua universe.";
    license.fullName = "MIT/X11";
  };
};

luaposix = buildLuarocksPackage {
  pname = "luaposix";
  version = "34.1.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/luaposix-34.1.1-1.src.rock";
    sha256 = "1l9pkn3g0nzlbmmfj12rhfwvkqb06c21ydqxqgmnmd3w9z4ck53w";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ bit32 lua ];

  meta = {
    homepage = "http://github.com/luaposix/luaposix/";
    description = "Lua bindings for POSIX";
    maintainers = with lib.maintainers; [ vyp lblasc ];
    license.fullName = "MIT/X11";
  };
};

luarepl = buildLuarocksPackage {
  pname = "luarepl";
  version = "0.9-1";

  src = fetchurl {
    url    = "https://github.com/hoelzro/lua-repl/archive/0.9.tar.gz";
    sha256 = "04xka7b84d9mrz3gyf8ywhw08xp65v8jrnzs8ry8k9540aqs721w";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/hoelzro/lua-repl";
    description = "A reusable REPL component for Lua, written in Lua";
    license.fullName = "MIT/X11";
  };
};

luasec = buildLuarocksPackage {
  pname = "luasec";
  version = "1.0.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/luasec-1.0.2-1.src.rock";
    sha256 = "1c3zqv2fbspvxplj3had9m3rij51bn9krx5kmdcqc3lgmn5d1mby";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luasocket ];

  meta = {
    homepage = "https://github.com/brunoos/luasec/wiki";
    description = "A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket.";
    maintainers = with lib.maintainers; [ flosse ];
    license.fullName = "MIT";
  };
};

luasocket = buildLuarocksPackage {
  pname = "luasocket";
  version = "3.0rc1-2";

  src = fetchurl {
    url    = "https://luarocks.org/luasocket-3.0rc1-2.src.rock";
    sha256 = "1isin9m40ixpqng6ds47skwa4zxrc6w8blza8gmmq566w6hz50iq";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://luaforge.net/projects/luasocket/";
    description = "Network support for the Lua language";
    license.fullName = "MIT";
  };
};

luasql-sqlite3 = buildLuarocksPackage {
  pname = "luasql-sqlite3";
  version = "2.6.0-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/keplerproject/luasql.git",
  "rev": "69f68a858134d6adbe9b65a902dcd3f60cd6a7ce",
  "date": "2021-08-27T15:17:22-03:00",
  "path": "/nix/store/2374agarn72cnlnk2vripfy1zz2y50la-luasql",
  "sha256": "13xs1g67d2p69x4wzxk1h97xh25388h0kkh9bjgw3l1yss9zlxhx",
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
};

luassert = buildLuarocksPackage {
  pname = "luassert";
  version = "1.8.0-0";

  src = fetchurl {
    url    = "https://github.com/Olivine-Labs/luassert/archive/v1.8.0.tar.gz";
    sha256 = "0xlwlb32215524bg33svp1ci8mdvh9wykchl8dkhihpxcd526mar";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua say ];

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description = "Lua Assertions Extension";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
};

luasystem = buildLuarocksPackage {
  pname = "luasystem";
  version = "0.2.1-0";

  src = fetchurl {
    url    = "https://luarocks.org/luasystem-0.2.1-0.src.rock";
    sha256 = "091xmp8cijgj0yzfsjrn7vljwznjnjn278ay7z9pjwpwiva0diyi";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://olivinelabs.com/luasystem/";
    description = "Platform independent system calls for Lua.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
};

luautf8 = buildLuarocksPackage {
  pname = "luautf8";
  version = "0.1.3-1";

  src = fetchurl {
    url    = "https://luarocks.org/luautf8-0.1.3-1.src.rock";
    sha256 = "1yp4j1r33yvsqf8cggmf4mhaxhz5lqzxhl9mnc0q5lh01yy5di48";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/starwing/luautf8";
    description = "A UTF-8 support module for Lua";
    maintainers = with lib.maintainers; [ pstn ];
    license.fullName = "MIT";
  };
};

luazip = buildLuarocksPackage {
  pname = "luazip";
  version = "1.2.7-1";

  src = fetchurl {
    url    = "https://luarocks.org/luazip-1.2.7-1.src.rock";
    sha256 = "1yprlr1ap6bhshhy88qfphmmyg9zp1py2hj2158iw6vsva0fk03l";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mpeterv/luazip";
    description = "Library for reading files inside zip files";
    license.fullName = "MIT";
  };
};

luuid = buildLuarocksPackage {
  pname = "luuid";
  version = "20120509-2";

  src = fetchurl {
    url    = "https://luarocks.org/luuid-20120509-2.src.rock";
    sha256 = "08q54x0m51w89np3n117h2a153wsgv3qayabd8cz6i55qm544hkg";
  };
  disabled = (luaOlder "5.2") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#luuid";
    description = "A library for UUID generation";
    license.fullName = "Public domain";
  };
};

luv = buildLuarocksPackage {
  pname = "luv";
  version = "1.30.0-0";

  src = fetchurl {
    url    = "https://luarocks.org/luv-1.30.0-0.src.rock";
    sha256 = "1z5sdq9ld4sm5pws9qxpk9cadv9i7ycwad1zwsa57pj67gly11vi";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/luvit/luv";
    description = "Bare libuv bindings for lua";
    license.fullName = "Apache 2.0";
  };
};

lyaml = buildLuarocksPackage {
  pname = "lyaml";
  version = "6.2.7-1";

  src = fetchurl {
    url    = "https://luarocks.org/lyaml-6.2.7-1.src.rock";
    sha256 = "1sh1q84n109j4sammgbzyr69ni7fxnrjfwqb49fsbrhhd49vw7ca";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://github.com/gvvaughan/lyaml";
    description = "libYAML binding for Lua";
    maintainers = with lib.maintainers; [ lblasc ];
    license.fullName = "MIT/X11";
  };
};

markdown = buildLuarocksPackage {
  pname = "markdown";
  version = "0.33-1";

  src = fetchurl {
    url    = "https://luarocks.org/markdown-0.33-1.src.rock";
    sha256 = "01xw4b4jvmrv1hz2gya02g3nphsj3hc94hsbc672ycj8pcql5n5y";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "https://github.com/mpeterv/markdown";
    description = "Markdown text-to-html markup system.";
    license.fullName = "MIT/X11";
  };
};

mediator_lua = buildLuarocksPackage {
  pname = "mediator_lua";
  version = "1.1.2-0";

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
};

moonscript = buildLuarocksPackage {
  pname = "moonscript";
  version = "0.5.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/moonscript-0.5.0-1.src.rock";
    sha256 = "09vv3ayzg94bjnzv5fw50r683ma0x3lb7sym297145zig9aqb9q9";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lpeg alt-getopt luafilesystem ];

  meta = {
    homepage = "http://moonscript.org";
    description = "A programmer friendly language that compiles to Lua";
    maintainers = with lib.maintainers; [ arobyn ];
    license.fullName = "MIT";
  };
};

mpack = buildLuarocksPackage {
  pname = "mpack";
  version = "1.0.8-0";

  src = fetchurl {
    url    = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.8/libmpack-lua-1.0.8.tar.gz";
    sha256 = "1sf93ffx7a3y1waknc4994l2yrxilrlf3hcp2cj2cvxmpm5inszd";
  };


  meta = {
    homepage = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.8/libmpack-lua-1.0.8.tar.gz";
    description = "Lua binding to libmpack";
    license.fullName = "MIT";
  };
};

nvim-client = buildLuarocksPackage {
  pname = "nvim-client";
  version = "0.2.2-1";

  src = fetchurl {
    url    = "https://github.com/neovim/lua-client/archive/0.2.2-1.tar.gz";
    sha256 = "1h736im524lq0vwlpihv9b317jarpkf3j13a25xl5qq8y8asm8mr";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua mpack luv coxpcall ];

  meta = {
    homepage = "https://github.com/neovim/lua-client";
    description = "Lua client to Nvim";
    license.fullName = "Apache";
  };
};

penlight = buildLuarocksPackage {
  pname = "penlight";
  version = "dev-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lunarmodules/penlight.git",
  "rev": "e3712f00fae09a166dd62540b677600165d5bcd7",
  "date": "2021-08-18T21:37:47+02:00",
  "path": "/nix/store/i70ndw8qhvcm828ifb3vyj08y22xp0ka-penlight",
  "sha256": "19n9xqkb4hlak0k7hamk4ixwjvyxslsnyh1zjazdzrl8n736xhkl",
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luafilesystem ];
  checkInputs = [ busted busted ];
  doCheck = true;

  meta = {
    homepage = "https://lunarmodules.github.io/penlight";
    description = "Lua utility libraries loosely based on the Python standard libraries";
    license.fullName = "MIT/X11";
  };
};

plenary-nvim = buildLuarocksPackage {
  pname = "plenary.nvim";
  version = "scm-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/nvim-lua/plenary.nvim",
  "rev": "15c3cb9e6311dc1a875eacb9fc8df69ca48d7402",
  "date": "2021-08-19T19:04:12+02:00",
  "path": "/nix/store/fjj6gs1yc9gw3qh3xabf7mra4dlyac5a-plenary.nvim",
  "sha256": "0gdysws82vdcyfsfpkpg9wqw223vg6hh74pf821wxh8p6qg3r26m",
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
};

rapidjson = buildLuarocksPackage {
  pname = "rapidjson";
  version = "0.7.1-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/xpol/lua-rapidjson",
  "rev": "242b40c8eaceb0cc43bcab88309736461cac1234",
  "date": "2021-04-09T19:59:20+08:00",
  "path": "/nix/store/65l71ph27pmipgrq8j4whg6n8h2avvs4-lua-rapidjson",
  "sha256": "1a6srvximxlh6gjkaj5y86d1kf06pc4gby2r6wpdw2pdac8k7xyb",
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
};

readline = buildLuarocksPackage {
  pname = "readline";
  version = "3.0-0";

  src = fetchurl {
    url    = "https://luarocks.org/readline-3.0-0.src.rock";
    sha256 = "0qpa60llcgvc5mj67a2w3il9i7700lvimraxjpk0lx44zkabh6c8";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua luaposix ];

  meta = {
    homepage = "http://pjb.com.au/comp/lua/readline.html";
    description = "Interface to the readline library";
    license.fullName = "MIT/X11";
  };
};

say = buildLuarocksPackage {
  pname = "say";
  version = "1.3-1";

  src = fetchurl {
    url    = "https://github.com/Olivine-Labs/say/archive/v1.3-1.tar.gz";
    sha256 = "1jh76mxq9dcmv7kps2spwcc6895jmj2sf04i4y9idaxlicvwvs13";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description = "Lua String Hashing/Indexing Library";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
};

std-_debug = buildLuarocksPackage {
  pname = "std._debug";
  version = "git-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lua-stdlib/_debug.git",
  "rev": "3236c1561bfc2724a3abd153a6e10c7957b35cf2",
  "date": "2020-04-15T16:34:01-07:00",
  "path": "/nix/store/rgbn0nn7glm7s52d90ds87j10bx20nij-_debug",
  "sha256": "0p6jz6syh2r8qfk08jf2hp4p902rkamjzpzl8xhkpzf8rdzs937w",
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
};

std-normalize = buildLuarocksPackage {
  pname = "std.normalize";
  version = "git-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lua-stdlib/normalize.git",
  "rev": "fb1d61b88b03406e291f58ec4981edfc538b8216",
  "date": "2020-04-15T17:16:16-07:00",
  "path": "/nix/store/jr4agcn13fk56b8105p6yr9gn767fkds-normalize",
  "sha256": "0jiykdjxc4b5my12fnzrw3bxracjgxc265xrn8kfx95350kvbzl1",
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
};

stdlib = buildLuarocksPackage {
  pname = "stdlib";
  version = "git-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/lua-stdlib/lua-stdlib.git",
  "rev": "a632078f216ac6b9994449b7f1435a419172b44f",
  "date": "2018-01-01T20:51:44-08:00",
  "path": "/nix/store/m9mqhcghsr178sjllv5ibbs588krd4qh-lua-stdlib",
  "sha256": "0hphmqyp33v90i3pjyr4p33c1pmglbzass8yzlaxfxp2ya7k2vsi",
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua std-_debug std-normalize ldoc ];

  meta = {
    homepage = "http://lua-stdlib.github.io/lua-stdlib";
    description = "General Lua Libraries";
    maintainers = with lib.maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
};

vstruct = buildLuarocksPackage {
  pname = "vstruct";
  version = "2.1.1-1";

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "https://github.com/ToxicFrog/vstruct.git",
  "rev": "b6889e3b275e9f9532b5dff4917e903b17e22730",
  "date": "2020-08-01T22:14:34-04:00",
  "path": "/nix/store/wayczacy4ds2j320f45yghw9arqzj5s9-vstruct",
  "sha256": "0mjvcybh4r8lwz5xncy8j49b864ndk0x5hkb409042glb6cw0s9g",
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
};


}
/* GENERATED - do not edit this file */
