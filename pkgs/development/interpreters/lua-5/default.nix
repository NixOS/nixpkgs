# similar to interpreters/python/default.nix
{ stdenv, lib, callPackage, fetchurl, fetchpatch }:

rec {
  lua5_4 = callPackage ./interpreter.nix {
    sourceVersion = { major = "5"; minor = "4"; patch = "3"; };
    hash = "1yxvjvnbg4nyrdv10bq42gz6dr66pyan28lgzfygqfwy2rv24qgq";

    patches = lib.optional stdenv.isDarwin ./5.4.darwin.patch;
  };

  lua5_4_compat = lua5_4.override({
    compat = true;
  });

  lua5_3 = callPackage ./interpreter.nix {
    sourceVersion = { major = "5"; minor = "3"; patch = "6"; };
    hash = "0q3d8qhd7p0b7a4mh9g7fxqksqfs6mr1nav74vq26qvkp2dxcpzw";

    patches =
      lib.optionals stdenv.isDarwin [ ./5.2.darwin.patch ];
  };

  lua5_3_compat = lua5_3.override({
    compat = true;
  });


  lua5_2 = callPackage ./interpreter.nix {
    sourceVersion = { major = "5"; minor = "2"; patch = "4"; };
    hash = "0jwznq0l8qg9wh5grwg07b5cy3lzngvl5m2nl1ikp6vqssmf9qmr";
    patches = lib.optional stdenv.isDarwin ./5.2.darwin.patch;
  };

  lua5_2_compat = lua5_2.override({
    compat = true;
  });


  lua5_1 = callPackage ./interpreter.nix {
    sourceVersion = { major = "5"; minor = "1"; patch = "5"; };
    hash = "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333";
    patches = (lib.optional stdenv.isDarwin ./5.1.darwin.patch)
      ++ [ ./CVE-2014-5461.patch ];
  };

  luajit_2_0 = import ../luajit/2.0.nix {
    self = luajit_2_0;
    inherit callPackage lib;
  };

  luajit_2_1 = import ../luajit/2.1.nix {
    self = luajit_2_1;
    inherit callPackage;
  };

}
