{ lib, stdenv, fetchurl
, ncurses
, libX11, xorgproto, buildEnv
, fetchpatch
, useX11 ? stdenv.hostPlatform.isx86
}:

let
   x11deps = [ libX11 xorgproto ];
   inherit (lib) optionals;

   baseOcamlBranch  = "4.11";
   baseOcamlVersion = "${baseOcamlBranch}.1";
   metaocamlPatch   = "111";
in

stdenv.mkDerivation rec {
  pname = "ber-metaocaml";
  version = metaocamlPatch;

  src = fetchurl {
    url = "https://caml.inria.fr/pub/distrib/ocaml-${baseOcamlBranch}/ocaml-${baseOcamlVersion}.tar.gz";
    sha256 = "sha256-3Yi2OFvZLgrZInMuKMxoyHd4QXcOoAPCC9FS9dtEFc4=";
  };

  metaocaml = fetchurl {
    url = "http://okmij.org/ftp/ML/ber-metaocaml-${metaocamlPatch}.tar.gz";
    sha256 = "sha256-hDb0w0ZCm0hCz8jktZKmr/7gPSfBoKPT/cc7sPjt0yE=";
  };

  x11env = buildEnv { name = "x11env"; paths = x11deps; };
  x11lib = "${x11env}/lib";
  x11inc = "${x11env}/include";

  prefixKey = "-prefix ";
  configureFlags = optionals useX11 [ "--enable-flambda" ];

  dontStrip = true;
  buildInputs = [ ncurses ] ++ optionals useX11 x11deps;

  patches = [
    # glibc 2.34 changed SIGSTKSZ from a #define'd integer to an
    # expression involving a function call.  This broke all code that
    # used SIGSTKSZ as the size of a statically-allocated array.  This
    # patch is also applied by the ocaml/4.07.nix expression.
    (fetchpatch {
      url = "https://github.com/ocaml/ocaml/commit/dd28ac0cf4365bd0ea1bcc374cbc5e95a6f39bea.patch";
      sha256 = "sha256-OmyovAu+8sgg3n5YD29Cytx3u/9PO2ofMsmrwiKUxks=";
    })
  ];

  postConfigure = ''
    tar -xvzf $metaocaml
    cd ${pname}-${version}
    make patch
    cd ..
  '';

  buildPhase = ''
    make world

    make bootstrap
    make opt.opt
    make -i install
    make installopt
    mkdir -p $out/include
    ln -sv $out/lib/ocaml/caml $out/include/caml
    cd ${pname}-${version}
    make all
  '';

  installPhase = ''
    make install
    make install.opt
  '';

  checkPhase = ''
    cd ${pname}-${version}
    make test
    make test-compile
    make test-native
    cd ..
  '';

  passthru = {
    nativeCompilers = true;
  };

  meta = with lib; {
    description     = "Multi-Stage Programming extension for OCaml";
    homepage        = "https://okmij.org/ftp/ML/MetaOCaml.html";
    license         = with licenses; [ /* compiler */ qpl /* library */ lgpl2 ];
    maintainers     = with maintainers; [ thoughtpolice ];

    branch          = baseOcamlBranch;
    platforms       = with platforms; linux ++ darwin;
    broken          = stdenv.isAarch64 || stdenv.isMips;

    longDescription = ''
      A simple extension of OCaml with the primitive type of code values, and
      three basic multi-stage expression forms: Brackets, Escape, and Run.
    '';
  };
}
