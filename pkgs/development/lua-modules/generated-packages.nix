
/* pkgs/development/lua-modules/generated-packages.nix is an auto-generated file -- DO NOT EDIT!
Regenerate it with:
nixpkgs$ maintainers/scripts/update-luarocks-packages pkgs/development/lua-modules/generated-packages.nix

These packages are manually refined in lua-overrides.nix
*/
{ self, stdenv, fetchurl, fetchgit, pkgs, ... } @ args:
self: super:
with self;
{

alt-getopt = buildLuarocksPackage {
  pname = "alt-getopt";
  version = "0.8.0-1";

  src = fetchurl {
    url    = https://luarocks.org/alt-getopt-0.8.0-1.src.rock;
    sha256 = "1mi97dqb97sf47vb6wrk12yf1yxcaz0asr9gbgwyngr5n1adh5i3";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/cheusov/lua-alt-getopt";
    description = "Process application arguments the same way as getopt_long";
    maintainers = with maintainers; [ arobyn ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
ansicolors = buildLuarocksPackage {
  pname = "ansicolors";
  version = "1.0.2-3";

  src = fetchurl {
    url    = https://luarocks.org/ansicolors-1.0.2-3.src.rock;
    sha256 = "1mhmr090y5394x1j8p44ws17sdwixn5a0r4i052bkfgk3982cqfz";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/kikito/ansicolors.lua";
    description = "Library for color Manipulation.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
argparse = buildLuarocksPackage {
  pname = "argparse";
  version = "0.6.0-1";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/argparse-0.6.0-1.src.rock;
    sha256 = "10ic5wppyghd1lmgwgl0lb40pv8z9fi9i87080axxg8wsr19y0p4";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mpeterv/argparse";
    description = "A feature-rich command-line argument parser";
    license = {
      fullName = "MIT";
    };
  };
};
basexx = buildLuarocksPackage {
  pname = "basexx";
  version = "0.4.1-1";

  knownRockspec = (fetchurl {
    url    = https://luarocks.org/basexx-0.4.1-1.rockspec;
    sha256 = "0kmydxm2wywl18cgj303apsx7hnfd68a9hx9yhq10fj7yfcxzv5f";
  }).outPath;

  src = fetchurl {
    url    = https://github.com/aiq/basexx/archive/v0.4.1.tar.gz;
    sha256 = "1rnz6xixxqwy0q6y2hi14rfid4w47h69gfi0rnlq24fz8q2b0qpz";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/aiq/basexx";
    description = "A base2, base16, base32, base64 and base85 library for Lua";
    license = {
      fullName = "MIT";
    };
  };
};
binaryheap = buildLuarocksPackage {
  pname = "binaryheap";
  version = "0.4-1";

  src = fetchurl {
    url    = https://luarocks.org/binaryheap-0.4-1.src.rock;
    sha256 = "11rd8r3bpinfla2965jgjdv1hilqdc1q6g1qla5978d7vzg19kpc";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Tieske/binaryheap.lua";
    description = "Binary heap implementation in pure Lua";
    maintainers = with maintainers; [ vcunat ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
bit32 = buildLuarocksPackage {
  pname = "bit32";
  version = "5.3.0-1";

  src = fetchurl {
    url    = https://luarocks.org/bit32-5.3.0-1.src.rock;
    sha256 = "19i7kc2pfg9hc6qjq4kka43q6qk71bkl2rzvrjaks6283q6wfyzy";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://www.lua.org/manual/5.2/manual.html#6.7";
    description = "Lua 5.2 bit manipulation library";
    maintainers = with maintainers; [ lblasc ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
busted = buildLuarocksPackage {
  pname = "busted";
  version = "2.0.rc13-0";

  knownRockspec = (fetchurl {
    url    = https://luarocks.org/busted-2.0.rc13-0.rockspec;
    sha256 = "0hrvhg1324q5ra6cpjh1y3by6lrzs0ljah4jl48l8xlgw1z9z1q5";
  }).outPath;

  src = fetchurl {
    url    = https://github.com/Olivine-Labs/busted/archive/v2.0.rc13-0.tar.gz;
    sha256 = "0m72bldn1r6j94ahcfmpaq1mmysrshf9qi9fjas7hpal0jp8ivvl";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lua_cliargs luafilesystem luasystem dkjson say luassert lua-term penlight mediator_lua ];

  meta = with stdenv.lib; {
    homepage = "http://olivinelabs.com/busted/";
    description = "Elegant Lua unit testing.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
cjson = buildLuarocksPackage {
  pname = "lua-cjson";
  version = "2.1.0.6-1";

  src = fetchurl {
    url    = https://luarocks.org/lua-cjson-2.1.0.6-1.src.rock;
    sha256 = "0dqqkn0aygc780kiq2lbydb255r8is7raf7md0gxdjcagp8afps5";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://www.kyne.com.au/~mark/software/lua-cjson.php";
    description = "A fast JSON encoding/parsing module";
    license = {
      fullName = "MIT";
    };
  };
};
compat53 = buildLuarocksPackage {
  pname = "compat53";
  version = "0.7-1";

  src = fetchurl {
    url    = https://luarocks.org/compat53-0.7-1.src.rock;
    sha256 = "0kpaxbpgrwjn4jjlb17fn29a09w6lw732d21bi0302kqcaixqpyb";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/keplerproject/lua-compat-5.3";
    description = "Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1";
    maintainers = with maintainers; [ vcunat ];
    license = {
      fullName = "MIT";
    };
  };
};
coxpcall = buildLuarocksPackage {
  pname = "coxpcall";
  version = "1.17.0-1";

  src = fetchurl {
    url    = https://luarocks.org/coxpcall-1.17.0-1.src.rock;
    sha256 = "0n1jmda4g7x06458596bamhzhcsly6x0p31yp6q3jz4j11zv1zhi";
  };

  meta = with stdenv.lib; {
    homepage = "http://keplerproject.github.io/coxpcall";
    description = "Coroutine safe xpcall and pcall";
    license = {
      fullName = "MIT/X11";
    };
  };
};
cqueues = buildLuarocksPackage {
  pname = "cqueues";
  version = "20190731.52-0";

  src = fetchurl {
    url    = https://luarocks.org/cqueues-20190731.52-0.src.rock;
    sha256 = "07rs34amsxf2bc5ccqdad0c63c70737r54316cbd9qh1a2wbvz8s";
  };
  disabled = (lua.luaversion != "5.2");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://25thandclement.com/~william/projects/cqueues.html";
    description = "Continuation Queues: Embeddable asynchronous networking, threading, and notification framework for Lua on Unix.";
    maintainers = with maintainers; [ vcunat ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
cyrussasl = buildLuarocksPackage {
  pname = "cyrussasl";
  version = "1.1.0-1";

  knownRockspec = (fetchurl {
    url    = https://luarocks.org/cyrussasl-1.1.0-1.rockspec;
    sha256 = "0zy9l00l7kr3sq8phdm52jqhlqy35vdv6rdmm8mhjihcbx1fsplc";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/JorjBauer/lua-cyrussasl",
  "rev": "78ceec610da76d745d0eff4e21a4fb24832aa72d",
  "date": "2015-08-21T18:24:54-04:00",
  "sha256": "14kzm3vk96k2i1m9f5zvpvq4pnzaf7s91h5g4h4x2bq1mynzw2s1",
  "fetchSubmodules": true
}
 '') ["date"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/JorjBauer/lua-cyrussasl";
    description = "Cyrus SASL library for Lua 5.1+";
    maintainers = with maintainers; [ vcunat ];
    license = {
      fullName = "BSD";
    };
  };
};
digestif = buildLuarocksPackage {
  pname = "digestif";
  version = "scm-1";

  knownRockspec = (fetchurl {
    url    = http://luarocks.org/dev/digestif-scm-1.rockspec;
    sha256 = "18rixbni4hmrmh3qj3vpjbsphzdvchswajphc9ysm52ccpyzh687";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/astoff/digestif",
  "rev": "51c321f1b68b77f648fa6adf356de48925f69fe0",
  "date": "2019-06-08T15:03:33+02:00",
  "sha256": "1c9cl81vfzirc325wipdy992yn20b8xv8nqzl5mdhyz8zfp84hs7",
  "fetchSubmodules": true
}
 '') ["date"]) ;

  disabled = (luaOlder "5.3");
  propagatedBuildInputs = [ lua lpeg dkjson ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/astoff/digestif/";
    description = "Code analyzer for TeX.";
    license = {
      fullName = "MIT";
    };
  };
};
dkjson = buildLuarocksPackage {
  pname = "dkjson";
  version = "2.5-2";

  src = fetchurl {
    url    = https://luarocks.org/dkjson-2.5-2.src.rock;
    sha256 = "1qy9bzqnb9pf9d48hik4iq8h68aw3270kmax7mmpvvpw7kkyp483";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://dkolf.de/src/dkjson-lua.fsl/";
    description = "David Kolf's JSON module for Lua";
    license = {
      fullName = "MIT/X11";
    };
  };
};
fifo = buildLuarocksPackage {
  pname = "fifo";
  version = "0.2-0";

  src = fetchurl {
    url    = https://luarocks.org/fifo-0.2-0.src.rock;
    sha256 = "082c5g1m8brnsqj5gnjs65bm7z50l6b05cfwah14lqaqsr5a5pjk";
  };
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/daurnimator/fifo.lua";
    description = "A lua library/'class' that implements a FIFO";
    license = {
      fullName = "MIT/X11";
    };
  };
};
http = buildLuarocksPackage {
  pname = "http";
  version = "0.3-0";

  src = fetchurl {
    url    = https://luarocks.org/http-0.3-0.src.rock;
    sha256 = "0vvl687bh3cvjjwbyp9cphqqccm3slv4g7y3h03scp3vpq9q4ccq";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua compat53 bit32 cqueues luaossl basexx lpeg lpeg_patterns binaryheap fifo ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/daurnimator/lua-http";
    description = "HTTP library for Lua";
    maintainers = with maintainers; [ vcunat ];
    license = {
      fullName = "MIT";
    };
  };
};
inspect = buildLuarocksPackage {
  pname = "inspect";
  version = "3.1.1-0";

  src = fetchurl {
    url    = https://luarocks.org/inspect-3.1.1-0.src.rock;
    sha256 = "0k4g9ahql83l4r2bykfs6sacf9l1wdpisav2i0z55fyfcdv387za";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/kikito/inspect.lua";
    description = "Lua table visualizer, ideal for debugging";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
ldoc = buildLuarocksPackage {
  pname = "ldoc";
  version = "1.4.6-2";

  knownRockspec = (fetchurl {
    url    = https://luarocks.org/ldoc-1.4.6-2.rockspec;
    sha256 = "14yb0qihizby8ja0fa82vx72vk903mv6m7izn39mzfrgb8mha0pm";
  }).outPath;

  src = fetchurl {
    url    = http://stevedonovan.github.io/files/ldoc-1.4.6.zip;
    sha256 = "1fvsmmjwk996ypzizcy565hj82bhj17vdb83ln6ff63mxr3zs1la";
  };

  propagatedBuildInputs = [ penlight markdown ];

  meta = with stdenv.lib; {
    homepage = "http://stevedonovan.github.com/ldoc";
    description = "A Lua Documentation Tool";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lgi = buildLuarocksPackage {
  pname = "lgi";
  version = "0.9.2-1";

  src = fetchurl {
    url    = https://luarocks.org/lgi-0.9.2-1.src.rock;
    sha256 = "07ajc5pdavp785mdyy82n0w6d592n96g95cvq025d6i0bcm2cypa";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/pavouk/lgi";
    description = "Lua bindings to GObject libraries";
    license = {
      fullName = "MIT/X11";
    };
  };
};
ljsyscall = buildLuarocksPackage {
  pname = "ljsyscall";
  version = "0.12-1";

  src = fetchurl {
    url    = https://luarocks.org/ljsyscall-0.12-1.src.rock;
    sha256 = "12gs81lnzpxi5d409lbrvjfflld5l2xsdkfhkz93xg7v65sfhh2j";
  };
  disabled = (lua.luaversion != "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://www.myriabit.com/ljsyscall/";
    description = "LuaJIT Linux syscall FFI";
    maintainers = with maintainers; [ lblasc ];
    license = {
      fullName = "MIT";
    };
  };
};
lpeg = buildLuarocksPackage {
  pname = "lpeg";
  version = "1.0.2-1";

  src = fetchurl {
    url    = https://luarocks.org/lpeg-1.0.2-1.src.rock;
    sha256 = "1g5zmfh0x7drc6mg2n0vvlga2hdc08cyp3hnb22mh1kzi63xdl70";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://www.inf.puc-rio.br/~roberto/lpeg.html";
    description = "Parsing Expression Grammars For Lua";
    maintainers = with maintainers; [ vyp ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
lpeg_patterns = buildLuarocksPackage {
  pname = "lpeg_patterns";
  version = "0.5-0";

  src = fetchurl {
    url    = https://luarocks.org/lpeg_patterns-0.5-0.src.rock;
    sha256 = "0mlw4nayrsdxrh98i26avz5i4170a9brciybw88kks496ra36v8f";
  };
  propagatedBuildInputs = [ lua lpeg ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/daurnimator/lpeg_patterns/archive/v0.5.zip";
    description = "a collection of LPEG patterns";
    license = {
      fullName = "MIT";
    };
  };
};
lpeglabel = buildLuarocksPackage {
  pname = "lpeglabel";
  version = "1.5.0-1";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lpeglabel-1.5.0-1.src.rock;
    sha256 = "068mwvwwn5n69pdm04qnk354391w9mk34jsczxql0xi5qgmz6w8j";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sqmedeiros/lpeglabel/";
    description = "Parsing Expression Grammars For Lua with Labeled Failures";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lpty = buildLuarocksPackage {
  pname = "lpty";
  version = "1.2.2-1";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lpty-1.2.2-1.src.rock;
    sha256 = "1vxvsjgjfirl6ranz6k4q4y2dnxqh72bndbk400if22x8lqbkxzm";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://www.tset.de/lpty/";
    description = "A simple facility for lua to control other programs via PTYs.";
    license = {
      fullName = "MIT";
    };
  };
};
lrexlib-gnu = buildLuarocksPackage {
  pname = "lrexlib-gnu";
  version = "2.9.0-1";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lrexlib-gnu-2.9.0-1.src.rock;
    sha256 = "036rda4rji1pbnbxk1nzjy5zmigdsiacqbzrbvciwq3lrxa2j5s2";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (GNU flavour).";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lrexlib-pcre = buildLuarocksPackage {
  pname = "lrexlib-pcre";
  version = "2.9.0-1";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lrexlib-pcre-2.9.0-1.src.rock;
    sha256 = "1nqai27lbd85mcjf5cb05dbdfg460vmp8cr0lmb8dd63ivk8cbvx";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (PCRE flavour).";
    maintainers = with maintainers; [ vyp ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
lrexlib-posix = buildLuarocksPackage {
  pname = "lrexlib-posix";
  version = "2.9.0-1";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lrexlib-posix-2.9.0-1.src.rock;
    sha256 = "0ifpybf4m94g1nk70l0f5m45gph0rbp5wrxrl1hnw8ibv3mc1b1r";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/rrthomas/lrexlib";
    description = "Regular expression library binding (POSIX flavour).";
    license = {
      fullName = "MIT/X11";
    };
  };
};
ltermbox = buildLuarocksPackage {
  pname = "ltermbox";
  version = "0.2-1";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/ltermbox-0.2-1.src.rock;
    sha256 = "08jqlmmskbi1ml1i34dlmg6hxcs60nlm32dahpxhcrgjnfihmyn8";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://code.google.com/p/termbox";
    description = "A termbox library package";
    license = {
      fullName = "New BSD License";
    };
  };
};
lua-cmsgpack = buildLuarocksPackage {
  pname = "lua-cmsgpack";
  version = "0.4.0-0";

  knownRockspec = (fetchurl {
    url    = https://luarocks.org/lua-cmsgpack-0.4.0-0.rockspec;
    sha256 = "10cvr6knx3qvjcw1q9v05f2qy607mai7lbq321nx682aa0n1fzin";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/antirez/lua-cmsgpack.git",
  "rev": "57b1f90cf6cec46450e87289ed5a676165d31071",
  "date": "2018-06-14T11:56:56+02:00",
  "sha256": "0yiwl4p1zh9qid3ksc4n9fv5bwaa9vjb0vgwnkars204xmxdj8fj",
  "fetchSubmodules": true
}
 '') ["date"]) ;

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/antirez/lua-cmsgpack";
    description = "MessagePack C implementation and bindings for Lua 5.1/5.2/5.3";
    license = {
      fullName = "Two-clause BSD";
    };
  };
};
lua-iconv = buildLuarocksPackage {
  pname = "lua-iconv";
  version = "7-3";

  src = fetchurl {
    url    = https://luarocks.org/lua-iconv-7-3.src.rock;
    sha256 = "03xibhcqwihyjhxnzv367q4bfmzmffxl49lmjsq77g0prw8v0q83";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://ittner.github.com/lua-iconv/";
    description = "Lua binding to the iconv";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lua-lsp = buildLuarocksPackage {
  pname = "lua-lsp";
  version = "scm-2";

  knownRockspec = (fetchurl {
    url    = http://luarocks.org/dev/lua-lsp-scm-2.rockspec;
    sha256 = "0qk3i6j0km4d1fs61fxhkmnbxmgpq24nygr8wknl6hbj2kya25rb";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/Alloyed/lua-lsp",
  "rev": "0de511803ed616214333210a2d003cf05a64dc18",
  "date": "2018-09-08T10:11:54-04:00",
  "sha256": "15dnsyh5664vi7qn73y2r114rhs5l9lfi84pwqkq5cafkiiy49qa",
  "fetchSubmodules": true
}
 '') ["date"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua dkjson lpeglabel inspect ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Alloyed/lua-lsp";
    description = "No summary";
    license = {
      fullName = "MIT";
    };
  };
};
lua-messagepack = buildLuarocksPackage {
  pname = "lua-messagepack";
  version = "0.5.1-2";

  src = fetchurl {
    url    = https://luarocks.org/lua-messagepack-0.5.1-2.src.rock;
    sha256 = "0bsdzdd24p9z3j4z1avw7qaqx87baa1pm58v275pw4h6n72z492g";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://fperrad.frama.io/lua-MessagePack/";
    description = "a pure Lua implementation of the MessagePack serialization format";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lua-term = buildLuarocksPackage {
  pname = "lua-term";
  version = "0.7-1";

  knownRockspec = (fetchurl {
    url    = https://luarocks.org/lua-term-0.7-1.rockspec;
    sha256 = "0r9g5jw7pqr1dyj6w58dqlr7y7l0jp077n8nnji4phf10biyrvg2";
  }).outPath;

  src = fetchurl {
    url    = https://github.com/hoelzro/lua-term/archive/0.07.tar.gz;
    sha256 = "0c3zc0cl3a5pbdn056vnlan16g0wimv0p9bq52h7w507f72x18f1";
  };


  meta = with stdenv.lib; {
    homepage = "https://github.com/hoelzro/lua-term";
    description = "Terminal functions for Lua";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lua-toml = buildLuarocksPackage {
  pname = "lua-toml";
  version = "2.0-1";

  src = fetchurl {
    url    = https://luarocks.org/lua-toml-2.0-1.src.rock;
    sha256 = "0lyqlnydqbplq82brw9ipqy9gijin6hj1wc46plz994pg4i2c74m";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/jonstoler/lua-toml";
    description = "toml decoder/encoder for Lua";
    license = {
      fullName = "MIT";
    };
  };
};
lua-zlib = buildLuarocksPackage {
  pname = "lua-zlib";
  version = "1.2-0";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lua-zlib-1.2-0.src.rock;
    sha256 = "0qa0vnx45nxdj6fqag6fr627zsnd2bmrr9bdbm8jv6lcnyi6nhs2";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/brimworks/lua-zlib";
    description = "Simple streaming interface to zlib for Lua.";
    maintainers = with maintainers; [ koral ];
    license = {
      fullName = "MIT";
    };
  };
};
lua_cliargs = buildLuarocksPackage {
  pname = "lua_cliargs";
  version = "3.0-2";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/lua_cliargs-3.0-2.src.rock;
    sha256 = "0qqdnw00r16xbyqn4w1xwwpg9i9ppc3c1dcypazjvdxaj899hy9w";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/amireh/lua_cliargs";
    description = "A command-line argument parser.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
luabitop = buildLuarocksPackage {
  pname = "luabitop";
  version = "1.0.2-3";

  knownRockspec = (fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/luabitop-1.0.2-3.rockspec;
    sha256 = "07y2h11hbxmby7kyhy3mda64w83p4a6p7y7rzrjqgc0r56yjxhcc";
  }).outPath;

  src = fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/LuaDist/luabitop.git",
  "rev": "81bb23b0e737805442033535de8e6d204d0e5381",
  "date": "2013-02-18T16:36:42+01:00",
  "sha256": "0lsc556hlkddjbmcdbg7wc2g55bfy743p8ywdzl8x7kk847r043q",
  "fetchSubmodules": true
}
 '') ["date"]) ;

  disabled = (luaOlder "5.1") || (luaAtLeast "5.3");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://bitop.luajit.org/";
    description = "Lua Bit Operations Module";
    license = {
      fullName = "MIT/X license";
    };
  };
};
luacheck = buildLuarocksPackage {
  pname = "luacheck";
  version = "0.23.0-1";

  src = fetchurl {
    url    = https://luarocks.org/luacheck-0.23.0-1.src.rock;
    sha256 = "0akj61c7k1na2mggsckvfn9a3ljfp4agnmr9gp3mac4vin99a1cl";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua argparse luafilesystem ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mpeterv/luacheck";
    description = "A static analyzer and a linter for Lua";
    license = {
      fullName = "MIT";
    };
  };
};
luacov = buildLuarocksPackage {
  pname = "luacov";
  version = "0.13.0-1";

  src = fetchurl {
    url    = mirror://luarocks/luacov-0.13.0-1.src.rock;
    sha256 = "16am0adzr4y64n94f64d4yrz65in8rwa8mmjz1p0k8afm5p5759i";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://keplerproject.github.io/luacov/";
    description = "Coverage analysis tool for Lua scripts";
    license = {
      fullName = "MIT";
    };
  };
};
luadbi = buildLuarocksPackage {
  pname = "luadbi";
  version = "0.7.2-1";

  src = fetchurl {
    url    = https://luarocks.org/luadbi-0.7.2-1.src.rock;
    sha256 = "0mj9ggyb05l03gs38ds508620mqaw4fkrzz9861n4j0zxbsbmfwy";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luadbi-mysql = buildLuarocksPackage {
  pname = "luadbi-mysql";
  version = "0.7.2-1";

  src = fetchurl {
    url    = https://luarocks.org/luadbi-mysql-0.7.2-1.src.rock;
    sha256 = "1f8i5p66halws8qsa7g09110hwzg7pv29yi22mkqd8sjgjv42iq4";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luadbi-postgresql = buildLuarocksPackage {
  pname = "luadbi-postgresql";
  version = "0.7.2-1";

  src = fetchurl {
    url    = https://luarocks.org/luadbi-postgresql-0.7.2-1.src.rock;
    sha256 = "0nmm1hdzl77wk8p6r6al6mpkh2n332a8r3iqsdi6v4nxamykdh28";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luadbi-sqlite3 = buildLuarocksPackage {
  pname = "luadbi-sqlite3";
  version = "0.7.2-1";

  src = fetchurl {
    url    = https://luarocks.org/luadbi-sqlite3-0.7.2-1.src.rock;
    sha256 = "17wd2djzk5x4l4pv2k3c7b8dcvl46s96kqyk8dp3q6ll8gdl7c65";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua luadbi ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mwild1/luadbi";
    description = "Database abstraction layer";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luadoc = buildLuarocksPackage {
  pname = "luadoc";
  version = "3.0.1-1";

  src = fetchurl {
    url    = mirror://luarocks/luadoc-3.0.1-1.src.rock;
    sha256 = "112zqjbzkrhx3nvavrxx3vhpv2ix85pznzzbpa8fq4piyv5r781i";
  };
  propagatedBuildInputs = [ lualogging luafilesystem ];

  meta = with stdenv.lib; {
    homepage = "http://luadoc.luaforge.net/";
    description = "LuaDoc is a documentation tool for Lua source code";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luaevent = buildLuarocksPackage {
  pname = "luaevent";
  version = "0.4.6-1";

  src = fetchurl {
    url    = https://luarocks.org/luaevent-0.4.6-1.src.rock;
    sha256 = "0chq09nawiz00lxd6pkdqcb8v426gdifjw6js3ql0lx5vqdkb6dz";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/harningt/luaevent";
    description = "libevent binding for Lua";
    license = {
      fullName = "MIT";
    };
  };
};
luaexpat = buildLuarocksPackage {
  pname = "luaexpat";
  version = "1.3.0-1";

  src = fetchurl {
    url    = https://luarocks.org/luaexpat-1.3.0-1.src.rock;
    sha256 = "15jqz5q12i9zvjyagzwz2lrpzya64mih8v1hxwr0wl2gsjh86y5a";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://www.keplerproject.org/luaexpat/";
    description = "XML Expat parsing";
    maintainers = with maintainers; [ arobyn flosse ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
luaffi = buildLuarocksPackage {
  pname = "luaffi";
  version = "scm-1";

  src = fetchurl {
    url    = http://luarocks.org/dev/luaffi-scm-1.src.rock;
    sha256 = "0dia66w8sgzw26bwy36gzyb2hyv7kh9n95lh5dl0158rqa6fsf26";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/facebook/luaffifb";
    description = "FFI library for calling C functions from lua";
    license = {
      fullName = "BSD";
    };
  };
};
luafilesystem = buildLuarocksPackage {
  pname = "luafilesystem";
  version = "1.7.0-2";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/luafilesystem-1.7.0-2.src.rock;
    sha256 = "0xhmd08zklsgpnpjr9rjipah35fbs8jd4v4va36xd8bpwlvx9rk5";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "git://github.com/keplerproject/luafilesystem";
    description = "File System Library for the Lua Programming Language";
    maintainers = with maintainers; [ flosse vcunat ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
lualogging = buildLuarocksPackage {
  pname = "lualogging";
  version = "1.3.0-1";

  src = fetchurl {
    url    = mirror://luarocks/lualogging-1.3.0-1.src.rock;
    sha256 = "13fm1vlig3zmbfkmlq1vk3xfqhlvv5xf24b0p4k4d08395y858vc";
  };
  propagatedBuildInputs = [ luasocket ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/Neopallium/lualogging";
    description = "A simple API to use logging features";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luaossl = buildLuarocksPackage {
  pname = "luaossl";
  version = "20190731-0";

  src = fetchurl {
    url    = https://luarocks.org/luaossl-20190731-0.src.rock;
    sha256 = "0gardlh547hah5w4kfsdg05jmxzrxr21macqigcmp5hw1l67jn5m";
  };
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://25thandclement.com/~william/projects/luaossl.html";
    description = "Most comprehensive OpenSSL module in the Lua universe.";
    maintainers = with maintainers; [ vcunat ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
luaposix = buildLuarocksPackage {
  pname = "luaposix";
  version = "34.0.4-1";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/luaposix-34.0.4-1.src.rock;
    sha256 = "0yrm5cn2iyd0zjd4liyj27srphvy0gjrjx572swar6zqr4dwjqp2";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ bit32 lua std_normalize ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/luaposix/luaposix/";
    description = "Lua bindings for POSIX";
    maintainers = with maintainers; [ vyp lblasc ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
luasec = buildLuarocksPackage {
  pname = "luasec";
  version = "0.8-1";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/luasec-0.8-1.src.rock;
    sha256 = "063rgz0zdmaizirsm6jbcfijgkpdcrb8a2fvhvg3y2s8ixbaff13";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua luasocket ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/brunoos/luasec/wiki";
    description = "A binding for OpenSSL library to provide TLS/SSL communication over LuaSocket.";
    maintainers = with maintainers; [ flosse ];
    license = {
      fullName = "MIT";
    };
  };
};
luasocket = buildLuarocksPackage {
  pname = "luasocket";
  version = "3.0rc1-2";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/luasocket-3.0rc1-2.src.rock;
    sha256 = "1isin9m40ixpqng6ds47skwa4zxrc6w8blza8gmmq566w6hz50iq";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://luaforge.net/projects/luasocket/";
    description = "Network support for the Lua language";
    license = {
      fullName = "MIT";
    };
  };
};
luasql-sqlite3 = buildLuarocksPackage {
  pname = "luasql-sqlite3";
  version = "2.4.0-1";

  src = fetchurl {
    url    = https://luarocks.org/luasql-sqlite3-2.4.0-1.src.rock;
    sha256 = "0pdk8c9iw0625imf5wdrhq60484jn475b85rvp0xgh86bsyalbsh";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://www.keplerproject.org/luasql/";
    description = "Database connectivity for Lua (SQLite3 driver)";
    maintainers = with maintainers; [ vyp ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
luassert = buildLuarocksPackage {
  pname = "luassert";
  version = "1.7.11-0";

  knownRockspec = (fetchurl {
    url    = https://luarocks.org/luassert-1.7.11-0.rockspec;
    sha256 = "12zgybcv8acjzvjdbxd1764s1vxbksxdv9fkvsymcsdmppxkbd0s";
  }).outPath;

  src = fetchurl {
    url    = https://github.com/Olivine-Labs/luassert/archive/v1.7.11.tar.gz;
    sha256 = "1vwq3wqj9cjyz9lnf1n38yhpcglr2h40v3n9096i8vcpmyvdb3ka";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua say ];

  meta = with stdenv.lib; {
    homepage = "http://olivinelabs.com/busted/";
    description = "Lua Assertions Extension";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
luasystem = buildLuarocksPackage {
  pname = "luasystem";
  version = "0.2.1-0";

  src = fetchurl {
    url    = https://luarocks.org/luasystem-0.2.1-0.src.rock;
    sha256 = "091xmp8cijgj0yzfsjrn7vljwznjnjn278ay7z9pjwpwiva0diyi";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://olivinelabs.com/luasystem/";
    description = "Platform independent system calls for Lua.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
luautf8 = buildLuarocksPackage {
  pname = "luautf8";
  version = "0.1.1-1";

  src = fetchurl {
    url    = https://luarocks.org/luautf8-0.1.1-1.src.rock;
    sha256 = "1832ilrlddh4h7ayx4l9j7z1p8c2hk5yr96cpxjjrmirkld23aji";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://github.com/starwing/luautf8";
    description = "A UTF-8 support module for Lua";
    maintainers = with maintainers; [ pstn ];
    license = {
      fullName = "MIT";
    };
  };
};
luazip = buildLuarocksPackage {
  pname = "luazip";
  version = "1.2.7-1";

  src = fetchurl {
    url    = https://luarocks.org/luazip-1.2.7-1.src.rock;
    sha256 = "1yprlr1ap6bhshhy88qfphmmyg9zp1py2hj2158iw6vsva0fk03l";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mpeterv/luazip";
    description = "Library for reading files inside zip files";
    license = {
      fullName = "MIT";
    };
  };
};
lua-yajl = buildLuarocksPackage {
  pname = "lua-yajl";
  version = "2.0-1";

  src = fetchurl {
    url    = https://luarocks.org/lua-yajl-2.0-1.src.rock;
    sha256 = "0bsm519vs53rchcdf8g96ygzdx2bz6pa4vffqlvc7ap49bg5np4f";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://github.com/brimworks/lua-yajl";
    description = "Integrate the yajl JSON library with Lua.";
    maintainers = with maintainers; [ pstn ];
    license = {
      fullName = "MIT/X11";
    };
  };
};
luuid = buildLuarocksPackage {
  pname = "luuid";
  version = "20120509-2";

  src = fetchurl {
    url    = https://luarocks.org/luuid-20120509-2.src.rock;
    sha256 = "08q54x0m51w89np3n117h2a153wsgv3qayabd8cz6i55qm544hkg";
  };
  disabled = (luaOlder "5.2") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#luuid";
    description = "A library for UUID generation";
    license = {
      fullName = "Public domain";
    };
  };
};
luv = buildLuarocksPackage {
  pname = "luv";
  version = "1.30.0-0";

  src = fetchurl {
    url    = https://luarocks.org/luv-1.30.0-0.src.rock;
    sha256 = "1z5sdq9ld4sm5pws9qxpk9cadv9i7ycwad1zwsa57pj67gly11vi";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/luvit/luv";
    description = "Bare libuv bindings for lua";
    license = {
      fullName = "Apache 2.0";
    };
  };
};
markdown = buildLuarocksPackage {
  pname = "markdown";
  version = "0.33-1";

  src = fetchurl {
    url    = https://luarocks.org/markdown-0.33-1.src.rock;
    sha256 = "01xw4b4jvmrv1hz2gya02g3nphsj3hc94hsbc672ycj8pcql5n5y";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mpeterv/markdown";
    description = "Markdown text-to-html markup system.";
    license = {
      fullName = "MIT/X11";
    };
  };
};
mediator_lua = buildLuarocksPackage {
  pname = "mediator_lua";
  version = "1.1.2-0";

  knownRockspec = (fetchurl {
    url    = https://luarocks.org/mediator_lua-1.1.2-0.rockspec;
    sha256 = "0frzvf7i256260a1s8xh92crwa2m42972qxfq29zl05aw3pyn7bm";
  }).outPath;

  src = fetchurl {
    url    = https://github.com/Olivine-Labs/mediator_lua/archive/v1.1.2-0.tar.gz;
    sha256 = "16zzzhiy3y35v8advmlkzpryzxv5vji7727vwkly86q8sagqbxgs";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://olivinelabs.com/mediator_lua/";
    description = "Event handling through channels";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
mpack = buildLuarocksPackage {
  pname = "mpack";
  version = "1.0.7-0";

  knownRockspec = (fetchurl {
    url    = https://luarocks.org/mpack-1.0.7-0.rockspec;
    sha256 = "1sdw8qsni3g3fx9jnc5g64nxfw6v3n1rrw1xa3bkwc9wk815lqnz";
  }).outPath;

  src = fetchurl {
    url    = https://github.com/libmpack/libmpack-lua/releases/download/1.0.7/libmpack-lua-1.0.7.tar.gz;
    sha256 = "1s4712ig3l4ds65pmlyg3r5zids2snn1rv8vsmmk27a4lf258mk8";
  };


  meta = with stdenv.lib; {
    homepage = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.7/libmpack-lua-1.0.7.tar.gz";
    description = "Lua binding to libmpack";
    license = {
      fullName = "MIT";
    };
  };
};
moonscript = buildLuarocksPackage {
  pname = "moonscript";
  version = "0.5.0-1";

  src = fetchurl {
    url    = https://raw.githubusercontent.com/rocks-moonscript-org/moonrocks-mirror/master/moonscript-0.5.0-1.src.rock;
    sha256 = "09vv3ayzg94bjnzv5fw50r683ma0x3lb7sym297145zig9aqb9q9";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua lpeg alt-getopt luafilesystem ];

  meta = with stdenv.lib; {
    homepage = "http://moonscript.org";
    description = "A programmer friendly language that compiles to Lua";
    maintainers = with maintainers; [ arobyn ];
    license = {
      fullName = "MIT";
    };
  };
};
nvim-client = buildLuarocksPackage {
  pname = "nvim-client";
  version = "0.2.0-1";

  src = fetchurl {
    url    = https://luarocks.org/nvim-client-0.2.0-1.src.rock;
    sha256 = "1ah9mjvz28hrbwnyb5n60znz3m0m41rn7jpnxwfx773cys3skidx";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua mpack luv coxpcall ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/neovim/lua-client/archive/0.2.0-1.tar.gz";
    description = "Lua client to Nvim";
    license = {
      fullName = "Apache";
    };
  };
};
penlight = buildLuarocksPackage {
  pname = "penlight";
  version = "1.5.4-1";

  knownRockspec = (fetchurl {
    url    = https://luarocks.org/penlight-1.5.4-1.rockspec;
    sha256 = "07mhsk9kmdxg4i2w4mrnnd2zs34bgggi9gigfplakxin96sa6c0p";
  }).outPath;

  src = fetchurl {
    url    = http://stevedonovan.github.io/files/penlight-1.5.4.zip;
    sha256 = "138f921p6kdqkmf4pz115phhj0jsqf28g33avws80d2vq2ixqm8q";
  };

  propagatedBuildInputs = [ luafilesystem ];

  meta = with stdenv.lib; {
    homepage = "http://stevedonovan.github.com/Penlight";
    description = "Lua utility libraries loosely based on the Python standard libraries";
    license = {
      fullName = "MIT/X11";
    };
  };
};
rapidjson = buildLuarocksPackage {
  pname = "rapidjson";
  version = "0.5.2-1";

  src = fetchurl {
    url    = https://luarocks.org/rapidjson-0.5.2-1.src.rock;
    sha256 = "17lgbzv9kairx49kwa0m8xwyly95mg6fw60jan2dpqwnnkf2m8y6";
  };
  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/xpol/lua-rapidjson";
    description = "Json module based on the very fast RapidJSON.";
    license = {
      fullName = "MIT";
    };
  };
};
say = buildLuarocksPackage {
  pname = "say";
  version = "1.3-1";

  knownRockspec = (fetchurl {
    url    = https://luarocks.org/say-1.3-1.rockspec;
    sha256 = "0bknglb0qwd6r703wp3hcb6z2xxd14kq4md3sg9al3b28fzxbhdv";
  }).outPath;

  src = fetchurl {
    url    = https://github.com/Olivine-Labs/say/archive/v1.3-1.tar.gz;
    sha256 = "1jh76mxq9dcmv7kps2spwcc6895jmj2sf04i4y9idaxlicvwvs13";
  };

  disabled = (luaOlder "5.1");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://olivinelabs.com/busted/";
    description = "Lua String Hashing/Indexing Library";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
std__debug = buildLuarocksPackage {
  pname = "std._debug";
  version = "1.0.1-1";

  src = fetchurl {
    url    = https://luarocks.org/std._debug-1.0.1-1.src.rock;
    sha256 = "1qkcc5rph3ns9mzrfsa1671pb3hzbzfnaxvyw7zdly2b7ll88svz";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://lua-stdlib.github.io/_debug";
    description = "Debug Hints Library";
    license = {
      fullName = "MIT/X11";
    };
  };
};
std_normalize = buildLuarocksPackage {
  pname = "std.normalize";
  version = "2.0.2-1";

  src = fetchurl {
    url    = https://luarocks.org/std.normalize-2.0.2-1.src.rock;
    sha256 = "0yn60zqnxflhhlv6xk6w0ifdfxk1qcg8gq1wnrrbwsxwpipsrfjh";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.4");
  propagatedBuildInputs = [ lua std__debug ];

  meta = with stdenv.lib; {
    homepage = "https://lua-stdlib.github.io/normalize";
    description = "Normalized Lua Functions";
    license = {
      fullName = "MIT/X11";
    };
  };
};
stdlib = buildLuarocksPackage {
  pname = "stdlib";
  version = "41.2.2-1";

  src = fetchurl {
    url    = https://luarocks.org/stdlib-41.2.2-1.src.rock;
    sha256 = "1kricll40xy75j72lrbp2jpyxsj9v8b9d7qjf3m3fq1bpg6dmsk7";
  };
  disabled = (luaOlder "5.1") || (luaAtLeast "5.5");
  propagatedBuildInputs = [ lua ];

  meta = with stdenv.lib; {
    homepage = "http://lua-stdlib.github.io/lua-stdlib";
    description = "General Lua Libraries";
    maintainers = with maintainers; [ vyp ];
    license = {
      fullName = "MIT/X11";
    };
  };
};

}
/* GENERATED */

