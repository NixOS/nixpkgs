{ stdenv, fetchFromGitHub, fetchurl
, ocaml, findlib, ocamlbuild, ocaml_oasis,
 bitstring, camlzip, cmdliner, core_kernel, ezjsonm, fileutils, ocaml_lwt, ocamlgraph, ocurl, re, uri, zarith, piqi, piqi-ocaml, uuidm, llvm, frontc, ounit, ppx_jane, parsexp,
 utop, libxml2,
 ppx_bitstring,
 ppx_tools_versioned,
 which, makeWrapper, writeText
, z3
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.07"
then throw "BAP is not available for OCaml ${ocaml.version}"
else

if stdenv.lib.versionAtLeast core_kernel.version "0.13"
then throw "BAP needs core_kernel-0.12 (hence OCaml 4.07)"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-bap-${version}";
  version = "2.1.0";
  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap";
    rev = "v${version}";
    sha256 = "10fkr6p798ad18j4h9bvp9dg4pmjdpv3hmj7k389i0vhqniwi5xq";
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
                  llvm ppx_bitstring ppx_tools_versioned
                  z3
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

  preConfigure = ''
    substituteInPlace oasis/elf --replace bitstring.ppx ppx_bitstring
  '';

  configureFlags = [ "--enable-everything ${disableIda}" "--with-llvm-config=${llvm}/bin/llvm-config" ];

  BAPBUILDFLAGS = "-j $(NIX_BUILD_CORES)";

  meta = with stdenv.lib; {
    description = "Platform for binary analysis. It is written in OCaml, but can be used from other languages.";
    homepage = "https://github.com/BinaryAnalysisPlatform/bap/";
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
  };
}
