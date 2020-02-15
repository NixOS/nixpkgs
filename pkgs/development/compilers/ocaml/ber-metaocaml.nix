{ stdenv, fetchurl
, ncurses
, libX11, xorgproto, buildEnv
}:

let
   useX11 = stdenv.isi686 || stdenv.isx86_64;
   x11deps = [ libX11 xorgproto ];
   inherit (stdenv.lib) optionals;

   baseOcamlBranch  = "4.07";
   baseOcamlVersion = "${baseOcamlBranch}.1";
   metaocamlPatch   = "107";
in

stdenv.mkDerivation rec {
  pname = "ber-metaocaml";
  version = metaocamlPatch;

  src = fetchurl {
    url = "https://caml.inria.fr/pub/distrib/ocaml-${baseOcamlBranch}/ocaml-${baseOcamlVersion}.tar.gz";
    sha256 = "1x4sln131mcspisr22qc304590rvg720rbl7g2i4xiymgvhkpm1a";
  };

  metaocaml = fetchurl {
    url = "http://okmij.org/ftp/ML/ber-metaocaml-107.tar.gz";
    sha256 = "0xy6n0yj1f53pk612zfmn49pn04bd75qa40xgmr0w0lzx6dqsfmm";
  };

  x11env = buildEnv { name = "x11env"; paths = x11deps; };
  x11lib = "${x11env}/lib";
  x11inc = "${x11env}/include";

  prefixKey = "-prefix ";
  configureFlags = optionals useX11
    [ "-x11lib" x11lib
      "-x11include" x11inc
      "-flambda"
    ];

  dontStrip = true;
  buildInputs = [ ncurses ] ++ optionals useX11 x11deps;

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

  meta = with stdenv.lib; {
    description     = "Multi-Stage Programming extension for OCaml";
    homepage        = http://okmij.org/ftp/ML/MetaOCaml.html;
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
