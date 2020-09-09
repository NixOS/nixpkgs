{ stdenv, fetchFromGitHub, fetchurl
, ocaml, findlib, ocamlbuild, ocaml_oasis,
 bitstring, camlzip, cmdliner, core_kernel, ezjsonm, fileutils, ocaml_lwt, ocamlgraph, ocurl, re, uri, zarith, piqi, piqi-ocaml, uuidm, llvm, frontc, ounit, ppx_jane, parsexp,
 utop, libxml2,
 ppx_tools_versioned,
 which, makeWrapper, writeText
}:

if stdenv.lib.versionAtLeast core_kernel.version "0.12"
then throw "BAP needs core_kernel-0.11 (hence OCaml ≤ 4.06)"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-bap-${version}";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap";
    rev = "v${version}";
    sha256 = "0lb9xkfp67wjjqr75p6krivmjra7l5673236v9ny4gp0xi0755bk";
  };

  sigs = fetchurl {
     url = "https://github.com/BinaryAnalysisPlatform/bap/releases/download/v${version}/sigs.zip";
     sha256 = "0d69jd28z4g64mglq94kj5imhmk5f6sgcsh9q2nij3b0arpcliwk";
  };

  createFindlibDestdir = true;

  setupHook = writeText "setupHook.sh" ''
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH-}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/${name}/"
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH-}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/${name}-llvm-plugins/"
  '';

  nativeBuildInputs = [ which makeWrapper ];

  buildInputs = [ ocaml findlib ocamlbuild ocaml_oasis
                  llvm ppx_tools_versioned
                  utop libxml2 ];

  propagatedBuildInputs = [ bitstring camlzip cmdliner ppx_jane core_kernel ezjsonm fileutils ocaml_lwt ocamlgraph ocurl re uri zarith piqi parsexp
                            piqi-ocaml uuidm frontc ounit ];

  installPhase = ''
    export OCAMLPATH=$OCAMLPATH:$OCAMLFIND_DESTDIR;
    export PATH=$PATH:$out/bin
    export CAML_LD_LIBRARY_PATH=''${CAML_LD_LIBRARY_PATH-}''${CAML_LD_LIBRARY_PATH:+:}$OCAMLFIND_DESTDIR/bap-plugin-llvm/:$OCAMLFIND_DESTDIR/bap/
    mkdir -p $out/lib/bap
    make install
    rm $out/bin/baptop
    makeWrapper ${utop}/bin/utop $out/bin/baptop --prefix OCAMLPATH : $OCAMLPATH --prefix PATH : $PATH --add-flags "-ppx ppx-bap -short-paths -require \"bap.top\""
    wrapProgram $out/bin/bapbuild --prefix OCAMLPATH : $OCAMLPATH --prefix PATH : $PATH
    ln -s $sigs $out/share/bap/sigs.zip
  '';

  disableIda = "--disable-ida";

  patches = [ ./dont-add-curses.patch ];

  configureFlags = [ "--enable-everything ${disableIda}" "--with-llvm-config=${llvm}/bin/llvm-config" ];

  BAPBUILDFLAGS = "-j $(NIX_BUILD_CORES)";

  meta = with stdenv.lib; {
    description = "Platform for binary analysis. It is written in OCaml, but can be used from other languages.";
    homepage = "https://github.com/BinaryAnalysisPlatform/bap/";
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
