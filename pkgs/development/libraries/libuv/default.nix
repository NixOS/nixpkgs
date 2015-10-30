{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool, pkgconfig

, ApplicationServices, CoreServices }:

let
  stable = "stable";
  unstable = "unstable";

  meta = with lib; {
    description = "A multi-platform support library with a focus on asynchronous I/O";
    homepage    = https://github.com/libuv/libuv;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = with platforms; linux ++ darwin;
  };

  mkName = stability: version:
    if stability == stable
    then "libuv-${version}"
    else "libuv-${stability}-${version}";

  mkSrc = version: sha256: fetchFromGitHub {
    owner = "libuv";
    repo = "libuv";
    rev = "v${version}";
    inherit sha256;
  };

  # for versions < 0.11.6
  mkWithoutAutotools = stability: version: sha256: stdenv.mkDerivation {
    name = mkName stability version;
    src = mkSrc version sha256;
    buildPhase = lib.optionalString stdenv.isDarwin ''
      mkdir extrapath
      ln -s /usr/sbin/dtrace extrapath/dtrace
      export PATH=$PATH:`pwd`/extrapath
    '' + ''
      mkdir build
      make builddir_name=build

      rm -r build/src
      rm build/libuv.a
      cp -r include build

      mkdir build/lib
      mv build/libuv.* build/lib

      pushd build/lib
      lib=$(basename libuv.*)
      ext="''${lib##*.}"
      mv $lib libuv.10.$ext
      ln -s libuv.10.$ext libuv.$ext
      popd
    '';
    installPhase = ''
      cp -r build $out
    '';
    inherit meta;
  };

  # for versions > 0.11.6
  mkWithAutotools = stability: version: sha256: stdenv.mkDerivation {
    name = mkName stability version;
    src = mkSrc version sha256;
    buildInputs = [ automake autoconf libtool pkgconfig ]
      ++ stdenv.lib.optionals stdenv.isDarwin [ ApplicationServices CoreServices ];
    preConfigure = ''
      LIBTOOLIZE=libtoolize ./autogen.sh
    '';
    inherit meta;
  };

  toVersion = with lib; name:
    replaceChars ["_"] ["."] (removePrefix "v" name);

in

  with lib;

  mapAttrs (v: h: mkWithAutotools unstable (toVersion v) h) {
    v0_11_29 = "1z07phfwryfy2155p3lxcm2a33h20sfl96lds5dghn157x6csz7m";
  }
  //
  mapAttrs (v: h: mkWithAutotools stable (toVersion v) h) {
    v1_7_5 = "18x6cy2xn31am97vn6jli7kmb2fbp4c8kmv7jm97vggh0x55flsc";
  }
