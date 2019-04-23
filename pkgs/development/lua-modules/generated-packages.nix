
/* pkgs/development/lua-modules/generated-packages.nix is an auto-generated file -- DO NOT EDIT!
Regenerate it with:
nixpkgs$ maintainers/scripts/update-luarocks-packages pkgs/development/lua-modules/generated-packages.nix

These packages are manually refined in lua-overrides.nix
*/
{ self, stdenv, fetchurl, fetchgit, pkgs, ... } @ args:
self: super:
with self;
{

ansicolors = buildLuarocksPackage {
  pname = "ansicolors";
  version = "1.0.2-3";

  src =  fetchurl {
      url    = https://luarocks.org/ansicolors-1.0.2-3.src.rock;
      sha256 = "1mhmr090y5394x1j8p44ws17sdwixn5a0r4i052bkfgk3982cqfz";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/kikito/ansicolors.lua";
    description="Library for color Manipulation.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
argparse = buildLuarocksPackage {
  pname = "argparse";
  version = "0.6.0-1";

  src =  fetchurl {
      url    = https://luarocks.org/argparse-0.6.0-1.src.rock;
      sha256 = "10ic5wppyghd1lmgwgl0lb40pv8z9fi9i87080axxg8wsr19y0p4";
   };
  disabled = ( luaOlder "5.1") || ( luaAtLeast "5.4");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/mpeterv/argparse";
    description="A feature-rich command-line argument parser";
    license = {
      fullName = "MIT";
    };
  };
};
basexx = buildLuarocksPackage {
  pname = "basexx";
  version = "0.4.0-1";

  src =  fetchurl {
      url    = https://luarocks.org/basexx-0.4.0-1.src.rock;
      sha256 = "1px8yrxg1qkk3kzdqj3siry742jdv4ysp2dmicxi15mkynqpjlzz";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/aiq/basexx";
    description="A base2, base16, base32, base64 and base85 library for Lua";
    license = {
      fullName = "MIT";
    };
  };
};
dkjson = buildLuarocksPackage {
  pname = "dkjson";
  version = "2.5-2";

  src =  fetchurl {
      url    = https://luarocks.org/dkjson-2.5-2.src.rock;
      sha256 = "1qy9bzqnb9pf9d48hik4iq8h68aw3270kmax7mmpvvpw7kkyp483";
   };
  disabled = ( luaOlder "5.1") || ( luaAtLeast "5.4");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "http://dkolf.de/src/dkjson-lua.fsl/";
    description="David Kolf's JSON module for Lua";
    license = {
      fullName = "MIT/X11";
    };
  };
};
fifo = buildLuarocksPackage {
  pname = "fifo";
  version = "0.2-0";

  src =  fetchurl {
      url    = https://luarocks.org/fifo-0.2-0.src.rock;
      sha256 = "082c5g1m8brnsqj5gnjs65bm7z50l6b05cfwah14lqaqsr5a5pjk";
   };

  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/daurnimator/fifo.lua";
    description="A lua library/'class' that implements a FIFO";
    license = {
      fullName = "MIT/X11";
    };
  };
};
inspect = buildLuarocksPackage {
  pname = "inspect";
  version = "3.1.1-0";

  src =  fetchurl {
      url    = https://luarocks.org/inspect-3.1.1-0.src.rock;
      sha256 = "0k4g9ahql83l4r2bykfs6sacf9l1wdpisav2i0z55fyfcdv387za";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/kikito/inspect.lua";
    description="Lua table visualizer, ideal for debugging";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
lgi = buildLuarocksPackage {
  pname = "lgi";
  version = "0.9.2-1";

  src =  fetchurl {
      url    = https://luarocks.org/lgi-0.9.2-1.src.rock;
      sha256 = "07ajc5pdavp785mdyy82n0w6d592n96g95cvq025d6i0bcm2cypa";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="make";

  meta = {
    homepage = "https://github.com/pavouk/lgi";
    description="Lua bindings to GObject libraries";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lpeg_patterns = buildLuarocksPackage {
  pname = "lpeg_patterns";
  version = "0.5-0";

  src =  fetchurl {
      url    = https://luarocks.org/lpeg_patterns-0.5-0.src.rock;
      sha256 = "0mlw4nayrsdxrh98i26avz5i4170a9brciybw88kks496ra36v8f";
   };

  propagatedBuildInputs = [lua lpeg  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/daurnimator/lpeg_patterns/archive/v0.5.zip";
    description="a collection of LPEG patterns";
    license = {
      fullName = "MIT";
    };
  };
};
lpty = buildLuarocksPackage {
  pname = "lpty";
  version = "1.2.2-1";

  src =  fetchurl {
      url    = https://luarocks.org/lpty-1.2.2-1.src.rock;
      sha256 = "1vxvsjgjfirl6ranz6k4q4y2dnxqh72bndbk400if22x8lqbkxzm";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="make";

  meta = {
    homepage = "http://www.tset.de/lpty/";
    description="A simple facility for lua to control other programs via PTYs.";
    license = {
      fullName = "MIT";
    };
  };
};
lrexlib-gnu = buildLuarocksPackage {
  pname = "lrexlib-gnu";
  version = "2.9.0-1";

  src =  fetchurl {
      url    = https://luarocks.org/lrexlib-gnu-2.9.0-1.src.rock;
      sha256 = "036rda4rji1pbnbxk1nzjy5zmigdsiacqbzrbvciwq3lrxa2j5s2";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/rrthomas/lrexlib";
    description="Regular expression library binding (GNU flavour).";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lrexlib-posix = buildLuarocksPackage {
  pname = "lrexlib-posix";
  version = "2.9.0-1";

  src =  fetchurl {
      url    = https://luarocks.org/lrexlib-posix-2.9.0-1.src.rock;
      sha256 = "0ifpybf4m94g1nk70l0f5m45gph0rbp5wrxrl1hnw8ibv3mc1b1r";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/rrthomas/lrexlib";
    description="Regular expression library binding (POSIX flavour).";
    license = {
      fullName = "MIT/X11";
    };
  };
};
ltermbox = buildLuarocksPackage {
  pname = "ltermbox";
  version = "0.2-1";

  src =  fetchurl {
      url    = https://luarocks.org/ltermbox-0.2-1.src.rock;
      sha256 = "08jqlmmskbi1ml1i34dlmg6hxcs60nlm32dahpxhcrgjnfihmyn8";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "http://code.google.com/p/termbox";
    description="A termbox library package";
    license = {
      fullName = "New BSD License";
    };
  };
};
lua-cmsgpack = buildLuarocksPackage {
  pname = "lua-cmsgpack";
  version = "0.4.0-0";

  knownRockspec = ( fetchurl {
      url    = https://luarocks.org/lua-cmsgpack-0.4.0-0.rockspec;
      sha256 = "10cvr6knx3qvjcw1q9v05f2qy607mai7lbq321nx682aa0n1fzin";
   }).outPath;

   src =  fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/antirez/lua-cmsgpack.git",
  "rev": "57b1f90cf6cec46450e87289ed5a676165d31071",
  "date": "2018-06-14T11:56:56+02:00",
  "sha256": "0yiwl4p1zh9qid3ksc4n9fv5bwaa9vjb0vgwnkars204xmxdj8fj",
  "fetchSubmodules": true
}
 '') ["date"]) ;

  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/antirez/lua-cmsgpack";
    description="MessagePack C implementation and bindings for Lua 5.1/5.2/5.3";
    license = {
      fullName = "Two-clause BSD";
    };
  };
};
lua_cliargs = buildLuarocksPackage {
  pname = "lua_cliargs";
  version = "3.0-2";

  src =  fetchurl {
      url    = https://luarocks.org/lua_cliargs-3.0-2.src.rock;
      sha256 = "0qqdnw00r16xbyqn4w1xwwpg9i9ppc3c1dcypazjvdxaj899hy9w";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/amireh/lua_cliargs";
    description="A command-line argument parser.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
lua-iconv = buildLuarocksPackage {
  pname = "lua-iconv";
  version = "7-3";

  src =  fetchurl {
      url    = https://luarocks.org/lua-iconv-7-3.src.rock;
      sha256 = "03xibhcqwihyjhxnzv367q4bfmzmffxl49lmjsq77g0prw8v0q83";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "http://ittner.github.com/lua-iconv/";
    description="Lua binding to the iconv";
    license = {
      fullName = "MIT/X11";
    };
  };
};
lua-term = buildLuarocksPackage {
  pname = "lua-term";
  version = "0.7-1";

  knownRockspec = ( fetchurl {
      url    = https://luarocks.org/lua-term-0.7-1.rockspec;
      sha256 = "0r9g5jw7pqr1dyj6w58dqlr7y7l0jp077n8nnji4phf10biyrvg2";
   }).outPath;

   src =  fetchurl {
      url    = https://github.com/hoelzro/lua-term/archive/0.07.tar.gz;
      sha256 = "0c3zc0cl3a5pbdn056vnlan16g0wimv0p9bq52h7w507f72x18f1";
   };



  buildType="builtin";

  meta = {
    homepage = "https://github.com/hoelzro/lua-term";
    description="Terminal functions for Lua";
    license = {
      fullName = "MIT/X11";
    };
  };
};
luaevent = buildLuarocksPackage {
  pname = "luaevent";
  version = "0.4.6-1";

  src =  fetchurl {
      url    = https://luarocks.org/luaevent-0.4.6-1.src.rock;
      sha256 = "0chq09nawiz00lxd6pkdqcb8v426gdifjw6js3ql0lx5vqdkb6dz";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/harningt/luaevent";
    description="libevent binding for Lua";
    license = {
      fullName = "MIT";
    };
  };
};
luabitop = buildLuarocksPackage {
  pname = "luabitop";
  version = "1.0.2-3";

  knownRockspec = ( fetchurl {
      url    = https://luarocks.org/luabitop-1.0.2-3.rockspec;
      sha256 = "07y2h11hbxmby7kyhy3mda64w83p4a6p7y7rzrjqgc0r56yjxhcc";
   }).outPath;

   src =  fetchgit ( removeAttrs (builtins.fromJSON ''{
  "url": "git://github.com/LuaDist/luabitop.git",
  "rev": "81bb23b0e737805442033535de8e6d204d0e5381",
  "date": "2013-02-18T16:36:42+01:00",
  "sha256": "0lsc556hlkddjbmcdbg7wc2g55bfy743p8ywdzl8x7kk847r043q",
  "fetchSubmodules": true
}
 '') ["date"]) ;

  disabled = ( luaOlder "5.1") || ( luaAtLeast "5.3");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "http://bitop.luajit.org/";
    description="Lua Bit Operations Module";
    license = {
      fullName = "MIT/X license";
    };
  };
};
luacheck = buildLuarocksPackage {
  pname = "luacheck";
  version = "0.23.0-1";

  src =  fetchurl {
      url    = https://luarocks.org/luacheck-0.23.0-1.src.rock;
      sha256 = "0akj61c7k1na2mggsckvfn9a3ljfp4agnmr9gp3mac4vin99a1cl";
   };
  disabled = ( luaOlder "5.1") || ( luaAtLeast "5.4");
  propagatedBuildInputs = [lua argparse luafilesystem  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/mpeterv/luacheck";
    description="A static analyzer and a linter for Lua";
    license = {
      fullName = "MIT";
    };
  };
};
luaffi = buildLuarocksPackage {
  pname = "luaffi";
  version = "scm-1";

  src =  fetchurl {
      url    = http://luarocks.org/dev/luaffi-scm-1.src.rock;
      sha256 = "0dia66w8sgzw26bwy36gzyb2hyv7kh9n95lh5dl0158rqa6fsf26";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/facebook/luaffifb";
    description="FFI library for calling C functions from lua";
    license = {
      fullName = "BSD";
    };
  };
};
luuid = buildLuarocksPackage {
  pname = "luuid";
  version = "20120509-2";

  src =  fetchurl {
      url    = https://luarocks.org/luuid-20120509-2.src.rock;
      sha256 = "08q54x0m51w89np3n117h2a153wsgv3qayabd8cz6i55qm544hkg";
   };
  disabled = ( luaOlder "5.2") || ( luaAtLeast "5.4");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "http://www.tecgraf.puc-rio.br/~lhf/ftp/lua/#luuid";
    description="A library for UUID generation";
    license = {
      fullName = "Public domain";
    };
  };
};
penlight = buildLuarocksPackage {
  pname = "penlight";
  version = "1.5.4-1";

  knownRockspec = ( fetchurl {
      url    = https://luarocks.org/penlight-1.5.4-1.rockspec;
      sha256 = "07mhsk9kmdxg4i2w4mrnnd2zs34bgggi9gigfplakxin96sa6c0p";
   }).outPath;

   src =  fetchurl {
      url    = http://stevedonovan.github.io/files/penlight-1.5.4.zip;
      sha256 = "138f921p6kdqkmf4pz115phhj0jsqf28g33avws80d2vq2ixqm8q";
   };


  propagatedBuildInputs = [luafilesystem  ];
  buildType="builtin";

  meta = {
    homepage = "http://stevedonovan.github.com/Penlight";
    description="Lua utility libraries loosely based on the Python standard libraries";
    license = {
      fullName = "MIT/X11";
    };
  };
};
say = buildLuarocksPackage {
  pname = "say";
  version = "1.3-1";

  knownRockspec = ( fetchurl {
      url    = https://luarocks.org/say-1.3-1.rockspec;
      sha256 = "0bknglb0qwd6r703wp3hcb6z2xxd14kq4md3sg9al3b28fzxbhdv";
   }).outPath;

   src =  fetchurl {
      url    = https://github.com/Olivine-Labs/say/archive/v1.3-1.tar.gz;
      sha256 = "1jh76mxq9dcmv7kps2spwcc6895jmj2sf04i4y9idaxlicvwvs13";
   };

  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description="Lua String Hashing/Indexing Library";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
luv = buildLuarocksPackage {
  pname = "luv";
  version = "1.22.0-1";

  knownRockspec = ( fetchurl {
      url    = https://luarocks.org/luv-1.22.0-1.rockspec;
      sha256 = "0yxjy9wj4aqbv1my8fkciy2xar5si6bcsszipgyls24rl6lnmga3";
   }).outPath;

   src =  fetchurl {
      url    = https://github.com/luvit/luv/releases/download/1.22.0-1/luv-1.22.0-1.tar.gz;
      sha256 = "1xvz4a0r6kd1xqxwm55g9n6imprxb79600x7dhyillrz7p5nm217";
   };

  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="cmake";

  meta = {
    homepage = "https://github.com/luvit/luv";
    description="Bare libuv bindings for lua";
    license = {
      fullName = "Apache 2.0";
    };
  };
};
luasystem = buildLuarocksPackage {
  pname = "luasystem";
  version = "0.2.1-0";

  src =  fetchurl {
      url    = https://luarocks.org/luasystem-0.2.1-0.src.rock;
      sha256 = "091xmp8cijgj0yzfsjrn7vljwznjnjn278ay7z9pjwpwiva0diyi";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "http://olivinelabs.com/luasystem/";
    description="Platform independent system calls for Lua.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
mediator_lua = buildLuarocksPackage {
  pname = "mediator_lua";
  version = "1.1.2-0";

  src =  fetchurl {
      url    = http://luarocks.org/manifests/teto/mediator_lua-1.1.2-0.src.rock;
      sha256 = "18j49vvs94yfk4fw0xsq4v3j4difr6c99gfba0kxairmcqamd1if";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua  ];
  buildType="builtin";

  meta = {
    homepage = "http://olivinelabs.com/mediator_lua/";
    description="Event handling through channels";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
mpack = buildLuarocksPackage {
  pname = "mpack";
  version = "1.0.7-0";

  src =  fetchurl {
      url    = http://luarocks.org/manifests/teto/mpack-1.0.7-0.src.rock;
      sha256 = "0nq4ixaminkc7fwfpivysyv0al3j5dffsvgdrnwnqdg3w7jgfbw7";
   };


  buildType="builtin";

  meta = {
    homepage = "https://github.com/libmpack/libmpack-lua/releases/download/1.0.7/libmpack-lua-1.0.7.tar.gz";
    description="Lua binding to libmpack";
    license = {
      fullName = "MIT";
    };
  };
};
nvim-client = buildLuarocksPackage {
  pname = "nvim-client";
  version = "0.1.0-1";

  src =  fetchurl {
      url    = https://luarocks.org/nvim-client-0.1.0-1.src.rock;
      sha256 = "1p57mrvm0ny3yi5cydr3z9qwzyg124rjp5w7vdflf2i23z39mkma";
   };
  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua mpack luv coxpcall  ];
  buildType="builtin";

  meta = {
    homepage = "https://github.com/neovim/lua-client/archive/0.1.0-1.tar.gz";
    description="Lua client to Nvim";
    license = {
      fullName = "Apache";
    };
  };
};
busted = buildLuarocksPackage {
  pname = "busted";
  version = "2.0.rc13-0";

  knownRockspec = ( fetchurl {
      url    = https://luarocks.org/busted-2.0.rc13-0.rockspec;
      sha256 = "0hrvhg1324q5ra6cpjh1y3by6lrzs0ljah4jl48l8xlgw1z9z1q5";
   }).outPath;

   src =  fetchurl {
      url    = https://github.com/Olivine-Labs/busted/archive/v2.0.rc13-0.tar.gz;
      sha256 = "0m72bldn1r6j94ahcfmpaq1mmysrshf9qi9fjas7hpal0jp8ivvl";
   };

  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua lua_cliargs luafilesystem luasystem dkjson say luassert lua-term penlight mediator_lua  ];
  buildType="builtin";

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description="Elegant Lua unit testing.";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
luassert = buildLuarocksPackage {
  pname = "luassert";
  version = "1.7.11-0";

  knownRockspec = ( fetchurl {
      url    = https://luarocks.org/luassert-1.7.11-0.rockspec;
      sha256 = "12zgybcv8acjzvjdbxd1764s1vxbksxdv9fkvsymcsdmppxkbd0s";
   }).outPath;

   src =  fetchurl {
      url    = https://github.com/Olivine-Labs/luassert/archive/v1.7.11.tar.gz;
      sha256 = "1vwq3wqj9cjyz9lnf1n38yhpcglr2h40v3n9096i8vcpmyvdb3ka";
   };

  disabled = ( luaOlder "5.1");
  propagatedBuildInputs = [lua say  ];
  buildType="builtin";

  meta = {
    homepage = "http://olivinelabs.com/busted/";
    description="Lua Assertions Extension";
    license = {
      fullName = "MIT <http://opensource.org/licenses/MIT>";
    };
  };
};
coxpcall = buildLuarocksPackage {
  pname = "coxpcall";
  version = "1.17.0-1";

  src =  fetchurl {
      url    = https://luarocks.org/manifests/hisham/coxpcall-1.17.0-1.src.rock;
      sha256 = "0n1jmda4g7x06458596bamhzhcsly6x0p31yp6q3jz4j11zv1zhi";
   };


  buildType="builtin";

  meta = {
    homepage = "http://keplerproject.github.io/coxpcall";
    description="Coroutine safe xpcall and pcall";
    license = {
      fullName = "MIT/X11";
    };
  };
};

}
/* GENERATED */

