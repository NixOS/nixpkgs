
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

  meta = with lib; {
    homepage = "https://github.com/cheusov/lua-alt-getopt";
    description = "Process application arguments the same way as getopt_long";
    maintainers = with maintainers; [ arobyn ];
    license.fullName = "MIT/X11";
  };
};

ansicolors = buildLuarocksPackage {
  pname = "ansicolors";
  version = "1.0.2-3";

  src = fetchurl {
    url    = "https://luarocks.org/ansicolors-1.0.2-3.src.rock";
    sha256 = "1mhmr090y5394x1j8p44ws17sdwixn5a0r4i052bkfgk3982cqfz";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "https://github.com/kikito/ansicolors.lua";
    description = "Library for color Manipulation.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
};

argparse = buildLuarocksPackage {
  pname = "argparse";
  version = "0.7.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/argparse-0.7.1-1.src.rock";
    sha256 = "0ybqh5jcb9v8f5xpq05av4hzrbk3vfvqrjj9cgmhm8l66mjd0c7a";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "https://github.com/luarocks/argparse";
    description = "A feature-rich command-line argument parser";
    license.fullName = "MIT";
  };
};

basexx = buildLuarocksPackage {
  pname = "basexx";
  version = "0.4.1-1";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/basexx-0.4.1-1.rockspec";
    sha256 = "0kmydxm2wywl18cgj303apsx7hnfd68a9hx9yhq10fj7yfcxzv5f";
  }).outPath;

  src = fetchurl {
    url    = "https://github.com/aiq/basexx/archive/v0.4.1.tar.gz";
    sha256 = "1rnz6xixxqwy0q6y2hi14rfid4w47h69gfi0rnlq24fz8q2b0qpz";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "https://github.com/aiq/basexx";
    description = "A base2, base16, base32, base64 and base85 library for Lua";
    license.fullName = "MIT";
  };
};

binaryheap = buildLuarocksPackage {
  pname = "binaryheap";
  version = "0.4-1";

  src = fetchurl {
    url    = "https://luarocks.org/binaryheap-0.4-1.src.rock";
    sha256 = "11rd8r3bpinfla2965jgjdv1hilqdc1q6g1qla5978d7vzg19kpc";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "https://github.com/Tieske/binaryheap.lua";
    description = "Binary heap implementation in pure Lua";
    maintainers = with maintainers; [ vcunat ];
    license.fullName = "MIT/X11";
  };
};

bit32 = buildLuarocksPackage {
  pname = "bit32";
  version = "5.3.5.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/bit32-5.3.0-1.src.rock";
    sha256 = "19i7kc2pfg9hc6qjq4kka43q6qk71bkl2rzvrjaks6283q6wfyzy";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "http://www.lua.org/manual/5.2/manual.html#6.7";
    description = "Lua 5.2 bit manipulation library";
    maintainers = with maintainers; [ lblasc ];
    license.fullName = "MIT";
  };
};

busted = buildLuarocksPackage {
  pname = "busted";
  version = "2.0.0-1";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/busted-2.0.0-1.rockspec";
    sha256 = "0cbw95bjxl667n9apcgng2kr5hq6bc7gp3vryw4dzixmfabxkcbw";
  }).outPath;

  src = fetchurl {
    url    = "https://github.com/Olivine-Labs/busted/archive/v2.0.0.tar.gz";
    sha256 = "1ps7b3f4diawfj637mibznaw4x08gn567pyni0m2s50hrnw4v8zx";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua_cliargs luafilesystem luasystem dkjson say luassert lua-term penlight mediator_lua ];

  meta = with lib; {
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

  meta = with lib; {
    homepage = "https://github.com/sile-typesetter/cassowary.lua";
    description = "The cassowary constraint solver";
    maintainers = with maintainers; [ marsam alerque ];
    license.fullName = "Apache 2";
  };
};
compat53 = buildLuarocksPackage {
  pname = "compat53";
  version = "0.8-1";

  src = fetchurl {
    url    = "https://luarocks.org/compat53-0.7-1.src.rock";
    sha256 = "0kpaxbpgrwjn4jjlb17fn29a09w6lw732d21bi0302kqcaixqpyb";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "https://github.com/keplerproject/lua-compat-5.3";
    description = "Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1";
    maintainers = with maintainers; [ vcunat ];
    license.fullName = "MIT";
  };
};

cosmo = buildLuarocksPackage {
  pname = "cosmo";
  version = "16.06.04-1";

  src = fetchurl {
    url    = "https://luarocks.org/cosmo-16.06.04-1.src.rock";
    sha256 = "1adrk74j0x1yzhy0xz9k80hphxdjvm09kpwpbx00sk3kic6db0ww";
  };
  propagatedBuildInputs = [ lpeg ];

  meta = with lib; {
    homepage = "http://cosmo.luaforge.net";
    description = "Safe templates for Lua";
    maintainers = with maintainers; [ marsam ];
    license.fullName = "MIT/X11";
  };
};

coxpcall = buildLuarocksPackage {
  pname = "coxpcall";
  version = "1.17.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/coxpcall-1.17.0-1.src.rock";
    sha256 = "0n1jmda4g7x06458596bamhzhcsly6x0p31yp6q3jz4j11zv1zhi";
  };

  meta = with lib; {
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

  meta = with lib; {
    homepage = "http://25thandclement.com/~william/projects/cqueues.html";
    description = "Continuation Queues: Embeddable asynchronous networking, threading, and notification framework for Lua on Unix.";
    maintainers = with maintainers; [ vcunat ];
    license.fullName = "MIT/X11";
  };
};

cyrussasl = buildLuarocksPackage {
  pname = "cyrussasl";
  version = "1.1.0-1";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/cyrussasl-1.1.0-1.rockspec";
    sha256 = "0zy9l00l7kr3sq8phdm52jqhlqy35vdv6rdmm8mhjihcbx1fsplc";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/JorjBauer/lua-cyrussasl",
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

  meta = with lib; {
    homepage = "http://github.com/JorjBauer/lua-cyrussasl";
    description = "Cyrus SASL library for Lua 5.1+";
    license.fullName = "BSD";
  };
};

digestif = buildLuarocksPackage {
  pname = "digestif";
  version = "0.4-1";

  src = fetchurl {
    url    = "mirror://luarocks/digestif-0.2-1.src.rock";
    sha256 = "03blpj5lxlhmxa4hnj21sz7sc84g96igbc7r97yb2smmlbyq8hxd";
  };
  disabled = (luaOlder "5.3");
  propagatedBuildInputs = [ lua lpeg dkjson ];

  meta = with lib; {
    homepage = "https://github.com/astoff/digestif/";
    description = "A code analyzer for TeX";
    license.fullName = "MIT";
  };
};

dkjson = buildLuarocksPackage {
  pname = "dkjson";
  version = "2.5-2";

  src = fetchurl {
    url    = "https://luarocks.org/dkjson-2.5-2.src.rock";
    sha256 = "1qy9bzqnb9pf9d48hik4iq8h68aw3270kmax7mmpvvpw7kkyp483";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
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

  meta = with lib; {
    homepage = "https://github.com/daurnimator/fifo.lua";
    description = "A lua library/'class' that implements a FIFO";
    license.fullName = "MIT/X11";
  };
};

http = buildLuarocksPackage {
  pname = "http";
  version = "0.4-0";

  src = fetchurl {
    url    = "https://luarocks.org/http-0.3-0.src.rock";
    sha256 = "0vvl687bh3cvjjwbyp9cphqqccm3slv4g7y3h03scp3vpq9q4ccq";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua compat53 bit32 cqueues luaossl basexx lpeg lpeg_patterns binaryheap fifo ];

  meta = with lib; {
    homepage = "https://github.com/daurnimator/lua-http";
    description = "HTTP library for Lua";
    maintainers = with maintainers; [ vcunat ];
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

  meta = with lib; {
    homepage = "https://github.com/kikito/inspect.lua";
    description = "Lua table visualizer, ideal for debugging";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
};

ldbus = buildLuarocksPackage {
  pname = "ldbus";
  version = "scm-0";

  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/ldbus-scm-0.rockspec";
    sha256 = "1yhkw5y8h1qf44vx31934k042cmnc7zcv2k0pv0g27wsmlxrlznx";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/daurnimator/ldbus.git",
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

  meta = with lib; {
    homepage = "https://github.com/daurnimator/ldbus";
    description = "A Lua library to access dbus.";
    license.fullName = "MIT/X11";
  };
};

ldoc = buildLuarocksPackage {
  pname = "ldoc";
  version = "1.4.6-2";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/ldoc-1.4.6-2.rockspec";
    sha256 = "14yb0qihizby8ja0fa82vx72vk903mv6m7izn39mzfrgb8mha0pm";
  }).outPath;

  src = fetchurl {
    url    = "http://stevedonovan.github.io/files/ldoc-1.4.6.zip";
    sha256 = "1fvsmmjwk996ypzizcy565hj82bhj17vdb83ln6ff63mxr3zs1la";
  };

  propagatedBuildInputs = [ penlight markdown ];

  meta = with lib; {
    homepage = "http://stevedonovan.github.com/ldoc";
    description = "A Lua Documentation Tool";
    license.fullName = "MIT/X11";
  };
};

lgi = buildLuarocksPackage {
  pname = "lgi";
  version = "0.9.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/lgi-0.9.2-1.src.rock";
    sha256 = "07ajc5pdavp785mdyy82n0w6d592n96g95cvq025d6i0bcm2cypa";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "http://github.com/pavouk/lgi";
    description = "Lua bindings to GObject libraries";
    license.fullName = "MIT/X11";
  };
};

linenoise = buildLuarocksPackage {
  pname = "linenoise";
  version = "0.9-1";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/linenoise-0.9-1.rockspec";
    sha256 = "0wic8g0d066pj9k51farsvcdbnhry2hphvng68w9k4lh0zh45yg4";
  }).outPath;

  src = fetchurl {
    url    = "https://github.com/hoelzro/lua-linenoise/archive/0.9.tar.gz";
    sha256 = "177h6gbq89arwiwxah9943i8hl5gvd9wivnd1nhmdl7d8x0dn76c";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
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

  meta = with lib; {
    homepage = "http://www.myriabit.com/ljsyscall/";
    description = "LuaJIT Linux syscall FFI";
    maintainers = with maintainers; [ lblasc ];
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

  meta = with lib; {
    homepage = "http://www.inf.puc-rio.br/~roberto/lpeg.html";
    description = "Parsing Expression Grammars For Lua";
    maintainers = with maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
};

lpeg_patterns = buildLuarocksPackage {
  pname = "lpeg_patterns";
  version = "0.5-0";

  src = fetchurl {
    url    = "https://luarocks.org/lpeg_patterns-0.5-0.src.rock";
    sha256 = "0mlw4nayrsdxrh98i26avz5i4170a9brciybw88kks496ra36v8f";
  };
  propagatedBuildInputs = [ lua lpeg ];

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (GNU flavour).";
    license.fullName = "MIT/X11";
  };
};

lrexlib-pcre = buildLuarocksPackage {
  pname = "lrexlib-pcre";
  version = "2.9.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/lrexlib-pcre-2.9.1-1.src.rock";
    sha256 = "0rsar13nax5r8f96pqjr0hf3civ1f1ijg4k7y69y5gi4wqd376lz";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (PCRE flavour).";
    maintainers = with maintainers; [ vyp ];
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

  meta = with lib; {
    homepage = "http://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (POSIX flavour).";
    license.fullName = "MIT/X11";
  };
};

ltermbox = buildLuarocksPackage {
  pname = "ltermbox";
  version = "0.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/ltermbox-0.2-1.src.rock";
    sha256 = "08jqlmmskbi1ml1i34dlmg6hxcs60nlm32dahpxhcrgjnfihmyn8";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "http://code.google.com/p/termbox";
    description = "A termbox library package";
    license.fullName = "New BSD License";
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

  meta = with lib; {
    homepage = "http://www.kyne.com.au/~mark/software/lua-cjson.php";
    description = "A fast JSON encoding/parsing module";
    license.fullName = "MIT";
  };
};

lua-cmsgpack = buildLuarocksPackage {
  pname = "lua-cmsgpack";
  version = "0.4.0-0";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-cmsgpack-0.4.0-0.rockspec";
    sha256 = "10cvr6knx3qvjcw1q9v05f2qy607mai7lbq321nx682aa0n1fzin";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/antirez/lua-cmsgpack.git",
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

  meta = with lib; {
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

  meta = with lib; {
    homepage = "http://ittner.github.com/lua-iconv/";
    description = "Lua binding to the iconv";
    license.fullName = "MIT/X11";
  };
};

lua-lsp = buildLuarocksPackage {
  pname = "lua-lsp";
  version = "scm-5";

  knownRockspec = (fetchurl {
    url    = "mirror://luarocks/lua-lsp-scm-5.rockspec";
    sha256 = "19nlnglg50vpz3wmqvnqafajjkqp8f2snqnfmihz3zi5rpdvzjya";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/Alloyed/lua-lsp",
  "rev": "91d4772d1cd264f8501c6da2326fc214ab0934f2",
  "date": "2020-10-31T00:55:09-04:00",
  "path": "/nix/store/awwwz5wq8v57kv69cfriivg7f6ipdx67-lua-lsp",
  "sha256": "10filff5vani6ligv7ls5dgq70k56hql26gv3x101snmw9fkjz57",
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua dkjson lpeglabel inspect ];

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
    homepage = "https://github.com/bungle/lua-resty-session";
    description = "Session Library for OpenResty – Flexible and Secure";
    license.fullName = "BSD";
  };
};

lua-term = buildLuarocksPackage {
  pname = "lua-term";
  version = "0.7-1";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-term-0.7-1.rockspec";
    sha256 = "0r9g5jw7pqr1dyj6w58dqlr7y7l0jp077n8nnji4phf10biyrvg2";
  }).outPath;

  src = fetchurl {
    url    = "https://github.com/hoelzro/lua-term/archive/0.07.tar.gz";
    sha256 = "0c3zc0cl3a5pbdn056vnlan16g0wimv0p9bq52h7w507f72x18f1";
  };


  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
    homepage = "http://github.com/brimworks/lua-yajl";
    description = "Integrate the yajl JSON library with Lua.";
    maintainers = with maintainers; [ pstn ];
    license.fullName = "MIT/X11";
  };
};

lua-zlib = buildLuarocksPackage {
  pname = "lua-zlib";
  version = "1.2-1";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/lua-zlib-1.2-1.rockspec";
    sha256 = "18rpbg9b4vsnh3svapiqrvwwshw1abb5l5fd7441byx1nm3fjq9w";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/brimworks/lua-zlib.git",
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

  meta = with lib; {
    homepage = "https://github.com/brimworks/lua-zlib";
    description = "Simple streaming interface to zlib for Lua.";
    maintainers = with maintainers; [ koral ];
    license.fullName = "MIT";
  };
};

lua_cliargs = buildLuarocksPackage {
  pname = "lua_cliargs";
  version = "3.0-2";

  src = fetchurl {
    url    = "https://luarocks.org/lua_cliargs-3.0-2.src.rock";
    sha256 = "0qqdnw00r16xbyqn4w1xwwpg9i9ppc3c1dcypazjvdxaj899hy9w";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "https://github.com/amireh/lua_cliargs";
    description = "A command-line argument parser.";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
};

luabitop = buildLuarocksPackage {
  pname = "luabitop";
  version = "1.0.2-3";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luabitop-1.0.2-3.rockspec";
    sha256 = "07y2h11hbxmby7kyhy3mda64w83p4a6p7y7rzrjqgc0r56yjxhcc";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/LuaDist/luabitop.git",
  "rev": "81bb23b0e737805442033535de8e6d204d0e5381",
  "date": "2013-02-18T16:36:42+01:00",
  "path": "/nix/store/jm7mls5zwkgkkf1hiwgbbwy94c55ir43-luabitop",
  "sha256": "0lsc556hlkddjbmcdbg7wc2g55bfy743p8ywdzl8x7kk847r043q",
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.3");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
    homepage = "https://github.com/harningt/luaevent";
    description = "libevent binding for Lua";
    license.fullName = "MIT";
  };
};

luaexpat = buildLuarocksPackage {
  pname = "luaexpat";
  version = "1.3.3-1";

  src = fetchurl {
    url    = "https://luarocks.org/luaexpat-1.3.0-1.src.rock";
    sha256 = "15jqz5q12i9zvjyagzwz2lrpzya64mih8v1hxwr0wl2gsjh86y5a";
  };
  disabled = (luaOlder "5.0");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "http://www.keplerproject.org/luaexpat/";
    description = "XML Expat parsing";
    maintainers = with maintainers; [ arobyn flosse ];
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

  meta = with lib; {
    homepage = "https://github.com/facebook/luaffifb";
    description = "FFI library for calling C functions from lua";
    license.fullName = "BSD";
  };
};

luafilesystem = buildLuarocksPackage {
  pname = "luafilesystem";
  version = "1.8.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/luafilesystem-1.7.0-2.src.rock";
    sha256 = "0xhmd08zklsgpnpjr9rjipah35fbs8jd4v4va36xd8bpwlvx9rk5";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "git://github.com/keplerproject/luafilesystem";
    description = "File System Library for the Lua Programming Language";
    maintainers = with maintainers; [ flosse ];
    license.fullName = "MIT/X11";
  };
};

lualogging = buildLuarocksPackage {
  pname = "lualogging";
  version = "1.5.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/lualogging-1.5.1-1.src.rock";
    sha256 = "1c98dnpfa2292g9xhpgsrfdvm80r1fhndrpay1hcgnq0qnz1sibh";
  };
  propagatedBuildInputs = [ luasocket ];

  meta = with lib; {
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

  meta = with lib; {
    homepage = "http://25thandclement.com/~william/projects/luaossl.html";
    description = "Most comprehensive OpenSSL module in the Lua universe.";
    license.fullName = "MIT/X11";
  };
};

luaposix = buildLuarocksPackage {
  pname = "luaposix";
  version = "35.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/luaposix-34.1.1-1.src.rock";
    sha256 = "1l9pkn3g0nzlbmmfj12rhfwvkqb06c21ydqxqgmnmd3w9z4ck53w";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "http://github.com/luaposix/luaposix/";
    description = "Lua bindings for POSIX";
    maintainers = with maintainers; [ vyp lblasc ];
    license.fullName = "MIT/X11";
  };
};

luarepl = buildLuarocksPackage {
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

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "https://github.com/hoelzro/lua-repl";
    description = "A reusable REPL component for Lua, written in Lua";
    license.fullName = "MIT/X11";
  };
};

luasec = buildLuarocksPackage {
  pname = "luasec";
  version = "1.0.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/luasec-1.0.1-1.src.rock";
    sha256 = "0384afx1w124ljs3hpp31ldqlrrgsa2xl625sxrx79yddilgk48f";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luasocket ];

  meta = with lib; {
    homepage = "https://github.com/brunoos/luasec/wiki";
    description = "A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket.";
    maintainers = with maintainers; [ flosse ];
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

  meta = with lib; {
    homepage = "http://luaforge.net/projects/luasocket/";
    description = "Network support for the Lua language";
    license.fullName = "MIT";
  };
};

luasql-sqlite3 = buildLuarocksPackage {
  pname = "luasql-sqlite3";
  version = "2.6.0-1";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/luasql-sqlite3-2.6.0-1.rockspec";
    sha256 = "0w32znsfcaklcja6avqx7daaxbf0hr2v8g8bmz0fysb3401lmp02";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/keplerproject/luasql.git",
  "rev": "8c58fd6ee32faf750daf6e99af015a31402578d1",
  "date": "2020-09-16T13:25:07+01:00",
  "path": "/nix/store/62g3f835iry7la34pw09dbqy2b7mn4q5-luasql",
  "sha256": "0jad5fin58mv36mdfz5jwg6hbcd7s32x39lyqymn1j9mxzjc2m2y",
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "http://www.keplerproject.org/luasql/";
    description = "Database connectivity for Lua (SQLite3 driver)";
    maintainers = with maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
};

luassert = buildLuarocksPackage {
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

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua say ];

  meta = with lib; {
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

  meta = with lib; {
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

  meta = with lib; {
    homepage = "http://github.com/starwing/luautf8";
    description = "A UTF-8 support module for Lua";
    maintainers = with maintainers; [ pstn ];
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

  meta = with lib; {
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

  meta = with lib; {
    homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#luuid";
    description = "A library for UUID generation";
    license.fullName = "Public domain";
  };
};

luv = buildLuarocksPackage {
  pname = "luv";
  version = "1.41.1-0";

  src = fetchurl {
    url    = "https://luarocks.org/luv-1.41.1-0.src.rock";
    sha256 = "0l1v07nhrkzsddbcc4bak382b5flyw6x8g4i394ylbfl25zwcmai";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
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

  meta = with lib; {
    homepage = "http://github.com/gvvaughan/lyaml";
    description = "libYAML binding for Lua";
    maintainers = with maintainers; [ lblasc ];
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

  meta = with lib; {
    homepage = "https://github.com/mpeterv/markdown";
    description = "Markdown text-to-html markup system.";
    license.fullName = "MIT/X11";
  };
};

mediator_lua = buildLuarocksPackage {
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

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
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

  meta = with lib; {
    homepage = "http://moonscript.org";
    description = "A programmer friendly language that compiles to Lua";
    maintainers = with maintainers; [ arobyn ];
    license.fullName = "MIT";
  };
};

mpack = buildLuarocksPackage {
  pname = "mpack";
  version = "1.0.8-0";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/mpack-1.0.8-0.rockspec";
    sha256 = "0hhpamw2bydnfrild274faaan6v48918nhslnw3kvi9y36b4i5ha";
  }).outPath;

  src = fetchurl {
    url    = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.8/libmpack-lua-1.0.8.tar.gz";
    sha256 = "1sf93ffx7a3y1waknc4994l2yrxilrlf3hcp2cj2cvxmpm5inszd";
  };


  meta = with lib; {
    homepage = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.8/libmpack-lua-1.0.8.tar.gz";
    description = "Lua binding to libmpack";
    license.fullName = "MIT";
  };
};
nvim-client = buildLuarocksPackage {
  pname = "nvim-client";
  version = "0.2.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/nvim-client-0.2.2-1.src.rock";
    sha256 = "0bgx94ziiq0004zw9lz2zb349xaqs5pminqd8bwdrfdnfjnbp8x0";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua mpack luv coxpcall ];

  meta = with lib; {
    homepage = "https://github.com/neovim/lua-client";
    description = "Lua client to Nvim";
    license.fullName = "Apache";
  };
};

penlight = buildLuarocksPackage {
  pname = "penlight";
  version = "1.10.0-1";

  src = fetchurl {
    url    = "https://luarocks.org/penlight-1.10.0-1.src.rock";
    sha256 = "1awd87833688wjdq8ynbzy1waia8ggaz573h9cqg1g2zm6d2mxvp";
  };
  propagatedBuildInputs = [ luafilesystem ];

  meta = with lib; {
    homepage = "https://lunarmodules.github.io/penlight";
    description = "Lua utility libraries loosely based on the Python standard libraries";
    license.fullName = "MIT/X11";
  };
};

plenary-nvim = buildLuarocksPackage {
  pname = "plenary.nvim";
  version = "scm-1";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/plenary.nvim-scm-1.rockspec";
    sha256 = "1cp2dzf3010q85h300aa7zphyz75qn67lrwf9v6b0p534nzvmash";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/nvim-lua/plenary.nvim",
  "rev": "d897b4d9fdbc51febd71a1f96c96001ae4fa6121",
  "date": "2021-08-03T08:49:43-04:00",
  "path": "/nix/store/nwarm7lh0r1rzmx92srq73x3r40whyw1-plenary.nvim",
  "sha256": "0rgqby4aakqamiw3ykvzhn3vd2grjkzgfxrpzjjp1ipkd2qak8mb",
  "fetchSubmodules": true,
  "deepClone": false,
  "leaveDotGit": false
}
 '') ["date" "path"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luassert ];

  meta = with lib; {
    homepage = "http://github.com/nvim-lua/plenary.nvim";
    description = "lua functions you don't want to write ";
    license.fullName = "MIT/X11";
  };
};

rapidjson = buildLuarocksPackage {
  pname = "rapidjson";
  version = "0.7.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/rapidjson-0.7.1-1.src.rock";
    sha256 = "010y1n7nlajdsm351fyqmi916v5x8kzp5hbynwlx5xc9r9480w81";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
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

  meta = with lib; {
    homepage = "http://pjb.com.au/comp/lua/readline.html";
    description = "Interface to the readline library";
    license.fullName = "MIT/X11";
  };
};

say = buildLuarocksPackage {
  pname = "say";
  version = "1.3-1";

  knownRockspec = (fetchurl {
    url    = "https://luarocks.org/say-1.3-1.rockspec";
    sha256 = "0bknglb0qwd6r703wp3hcb6z2xxd14kq4md3sg9al3b28fzxbhdv";
  }).outPath;

  src = fetchurl {
    url    = "https://github.com/Olivine-Labs/say/archive/v1.3-1.tar.gz";
    sha256 = "1jh76mxq9dcmv7kps2spwcc6895jmj2sf04i4y9idaxlicvwvs13";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "http://olivinelabs.com/busted/";
    description = "Lua String Hashing/Indexing Library";
    license.fullName = "MIT <http://opensource.org/licenses/MIT>";
  };
};

std-_debug = buildLuarocksPackage {
  pname = "std._debug";
  version = "1.0.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/std._debug-1.0.1-1.src.rock";
    sha256 = "1qkcc5rph3ns9mzrfsa1671pb3hzbzfnaxvyw7zdly2b7ll88svz";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "http://lua-stdlib.github.io/_debug";
    description = "Debug Hints Library";
    license.fullName = "MIT/X11";
  };
};

std-normalize = buildLuarocksPackage {
  pname = "std.normalize";
  version = "2.0.3-1";

  src = fetchurl {
    url    = "https://luarocks.org/std.normalize-2.0.3-1.src.rock";
    sha256 = "00pq2y5w8i052gxmyhgri5ibijksnfmc24kya9y3d5rjlin0n11s";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua std-_debug ];

  meta = with lib; {
    homepage = "https://lua-stdlib.github.io/normalize";
    description = "Normalized Lua Functions";
    license.fullName = "MIT/X11";
  };
};

stdlib = buildLuarocksPackage {
  pname = "stdlib";
  version = "41.2.2-1";

  src = fetchurl {
    url    = "https://luarocks.org/stdlib-41.2.2-1.src.rock";
    sha256 = "1kricll40xy75j72lrbp2jpyxsj9v8b9d7qjf3m3fq1bpg6dmsk7";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "http://lua-stdlib.github.io/lua-stdlib";
    description = "General Lua Libraries";
    maintainers = with maintainers; [ vyp ];
    license.fullName = "MIT/X11";
  };
};

vstruct = buildLuarocksPackage {
  pname = "vstruct";
  version = "2.1.1-1";

  src = fetchurl {
    url    = "https://luarocks.org/vstruct-2.1.1-1.src.rock";
    sha256 = "0hdlq8dr27k32n5qr87yisl14wg0k0zqd990xqvjqdxrf8d7iypw";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with lib; {
    homepage = "https://github.com/ToxicFrog/vstruct";
    description = "Lua library to manipulate binary data";
  };
};


}
/* GENERATED - do not edit this file */
