{ stdenv, fetchFromGitHub, fetchurl, fetchpatch
, ocaml, findlib, ocamlbuild, ocaml_oasis,
 bitstring, camlzip, cmdliner, core_kernel, ezjsonm, faillib, fileutils, ocaml_lwt, ocamlgraph, ocurl, re, uri, zarith, piqi, piqi-ocaml, uuidm, llvm_38, frontc, ounit, ppx_jane, parsexp,
 utop,
 ppx_tools_versioned,
 which, makeWrapper, writeText
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-bap-${version}";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap";
    rev = "v${version}";
    sha256 = "0ryf2xb37pj2f9mc3p5prqgqrylph9qgq7q9jnbx8b03nzzpa6h6";
  };

  sigs = fetchurl {
     url = "https://github.com/BinaryAnalysisPlatform/bap/releases/download/v${version}/sigs.zip";
     sha256 = "0d69jd28z4g64mglq94kj5imhmk5f6sgcsh9q2nij3b0arpcliwk";
  };

  createFindlibDestdir = true;

  setupHook = writeText "setupHook.sh" ''
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/${name}/"
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/${name}-llvm-plugins/"
  '';

  nativeBuildInputs = [ which makeWrapper ];

  buildInputs = [ ocaml findlib ocamlbuild ocaml_oasis
                  llvm_38 ppx_tools_versioned
                  utop ];

  propagatedBuildInputs = [ bitstring camlzip cmdliner ppx_jane core_kernel ezjsonm fileutils ocaml_lwt ocamlgraph ocurl re uri zarith piqi parsexp
                            piqi-ocaml uuidm frontc ounit ];

  installPhase = ''
    export OCAMLPATH=$OCAMLPATH:$OCAMLFIND_DESTDIR;
    export PATH=$PATH:$out/bin
    export CAML_LD_LIBRARY_PATH=$CAML_LD_LIBRARY_PATH:$OCAMLFIND_DESTDIR/bap-plugin-llvm/:$OCAMLFIND_DESTDIR/bap/
    mkdir -p $out/lib/bap
    make install
    rm $out/bin/baptop
    makeWrapper ${utop}/bin/utop $out/bin/baptop --prefix OCAMLPATH : $OCAMLPATH --prefix PATH : $PATH --add-flags "-ppx ppx-bap -short-paths -require \"bap.top\""
    wrapProgram $out/bin/bapbuild --prefix OCAMLPATH : $OCAMLPATH --prefix PATH : $PATH
    ln -s $sigs $out/share/bap/sigs.zip
  '';

  disableIda = "--disable-ida --disable-fsi-benchmark";

  configureFlags = [ "--enable-everything ${disableIda}" "--with-llvm-config=${llvm_38}/bin/llvm-config" ];

  BAPBUILDFLAGS = "-j $(NIX_BUILD_CORES)";

  meta = with stdenv.lib; {
    description = "Platform for binary analysis. It is written in OCaml, but can be used from other languages.";
    homepage = https://github.com/BinaryAnalysisPlatform/bap/;
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
