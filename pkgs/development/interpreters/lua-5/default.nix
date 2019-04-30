# similar to interpreters/python/default.nix
{ stdenv, lib, callPackage, fetchurl }:
let
  dsoPatch51 = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/lua-arch.patch?h=packages/lua51";
    sha256 = "11fcyb4q55p4p7kdb8yp85xlw8imy14kzamp2khvcyxss4vw8ipw";
    name = "lua-arch.patch";
  };

  dsoPatch52 = fetchurl {
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/liblua.so.patch?h=packages/lua52";
    sha256 = "1by1dy4ql61f5c6njq9ibf9kaqm3y633g2q8j54iyjr4cxvqwqz9";
    name = "lua-arch.patch";
  };

in rec {

  lua5_3 = callPackage ./interpreter.nix {
    sourceVersion = { major = "5"; minor = "3"; patch = "5"; };
    hash = "0c2eed3f960446e1a3e4b9a1ca2f3ff893b6ce41942cf54d5dd59ab4b3b058ac";
    patches = lib.optionals stdenv.isDarwin [ ./5.2.darwin.patch ] ;
    postConfigure = lib.optionalString (!stdenv.isDarwin) ''
      cat ${./lua-5.3-dso.make} >> src/Makefile
      sed -e 's/ALL_T *= */& $(LUA_SO)/' -i src/Makefile
    '';

    postBuild = stdenv.lib.optionalString (!stdenv.isDarwin) ''
      ( cd src; make $makeFlags "''${makeFlagsArray[@]}" liblua.so )
    '';
  };

  lua5_3_compat = lua5_3.override({
    compat = true;
  });


  lua5_2 = callPackage ./interpreter.nix {
    sourceVersion = { major = "5"; minor = "2"; patch = "4"; };
    hash = "0jwznq0l8qg9wh5grwg07b5cy3lzngvl5m2nl1ikp6vqssmf9qmr";
    patches = if stdenv.isDarwin then [ ./5.2.darwin.patch ] else [ dsoPatch52 ];
  };

  lua5_2_compat = lua5_2.override({
    compat = true;
  });


  lua5_1 = callPackage ./interpreter.nix {
    sourceVersion = { major = "5"; minor = "1"; patch = "5"; };
    hash = "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333";
    patches = (if stdenv.isDarwin then [ ./5.1.darwin.patch ] else [ dsoPatch51 ])
      ++ [ ./5.1.0004-Fix-stack-overflow-in-vararg-functions.patch ];
  };

  luajit_2_0 = import ../luajit/2.0.nix {
    self = luajit_2_0;
    inherit callPackage lib;
  };

  luajit_2_1 = import ../luajit/2.1.nix {
    self = luajit_2_1;
    inherit callPackage lib;
  };

}
