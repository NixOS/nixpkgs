# similar to interpreters/python/default.nix
{ stdenv, lib, callPackage, fetchurl, fetchpatch, makeBinaryWrapper }:

rec {
  lua5_4 = callPackage ./interpreter.nix {
    sourceVersion = { major = "5"; minor = "4"; patch = "3"; };
    hash = "1yxvjvnbg4nyrdv10bq42gz6dr66pyan28lgzfygqfwy2rv24qgq";
    makeWrapper = makeBinaryWrapper;

    patches = lib.optional stdenv.isDarwin ./5.4.darwin.patch
      ++ [
        (fetchpatch {
          name = "CVE-2022-28805.patch";
          url = "https://github.com/lua/lua/commit/1f3c6f4534c6411313361697d98d1145a1f030fa.patch";
          sha256 = "sha256-YTwoolSnRNJIHFPVijSO6ZDw35BG5oWYralZ8qOb9y8=";
          stripLen = 1;
          extraPrefix = "src/";
          excludes = [ "src/testes/*" ];
        })
        (fetchpatch {
          name = "CVE-2022-33099.patch";
          url = "https://github.com/lua/lua/commit/42d40581dd919fb134c07027ca1ce0844c670daf.patch";
          sha256 = "sha256-qj1Dq1ojVoknALSa67jhgH3G3Kk4GtJP6ROFElVF+D0=";
          stripLen = 1;
          extraPrefix = "src/";
        })
      ];
  };

  lua5_4_compat = lua5_4.override({
    compat = true;
  });

  lua5_3 = callPackage ./interpreter.nix {
    sourceVersion = { major = "5"; minor = "3"; patch = "6"; };
    hash = "0q3d8qhd7p0b7a4mh9g7fxqksqfs6mr1nav74vq26qvkp2dxcpzw";
    makeWrapper = makeBinaryWrapper;

    patches =
      lib.optionals stdenv.isDarwin [ ./5.2.darwin.patch ];
  };

  lua5_3_compat = lua5_3.override({
    compat = true;
  });


  lua5_2 = callPackage ./interpreter.nix {
    sourceVersion = { major = "5"; minor = "2"; patch = "4"; };
    hash = "0jwznq0l8qg9wh5grwg07b5cy3lzngvl5m2nl1ikp6vqssmf9qmr";
    makeWrapper = makeBinaryWrapper;
    patches = [
      ./CVE-2022-28805.patch
    ] ++ lib.optional stdenv.isDarwin ./5.2.darwin.patch;
  };

  lua5_2_compat = lua5_2.override({
    compat = true;
  });


  lua5_1 = callPackage ./interpreter.nix {
    sourceVersion = { major = "5"; minor = "1"; patch = "5"; };
    hash = "2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333";
    makeWrapper = makeBinaryWrapper;
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
