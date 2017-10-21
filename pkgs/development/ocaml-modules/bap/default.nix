{stdenv, buildOcaml, fetchFromGitHub, fetchurl, camlp4, ocaml_oasis, bitstring, camlzip, cmdliner, core_kernel, ezjsonm, faillib, fileutils, ocaml_lwt, ocamlgraph, ocurl, re, uri, zarith, piqi, piqi-ocaml, uuidm, llvm_38, ulex, easy-format, xmlm, frontc, ounit, utop, which, makeWrapper, writeText, ocaml}:

buildOcaml rec {
  name = "bap";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "BinaryAnalysisPlatform";
    repo = "bap";
    rev = "v${version}";
    sha256 = "0dn1gvj73pma0rsw8r50cmjddibnf42w1kbskb2vpzq0kb79jlkw";
  };

  sigs = fetchurl {
     url = "https://github.com/BinaryAnalysisPlatform/bap/releases/download/v${version}/sigs.zip";
     sha256 = "0mpsq2pinbrynlisnh8j3nrlamlsls7lza0bkqnm9szqjjdmcgfn";
  };

  createFindlibDestdir = true;

  setupHook = writeText "setupHook.sh" ''
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/${name}/"
    export CAML_LD_LIBRARY_PATH="''${CAML_LD_LIBRARY_PATH}''${CAML_LD_LIBRARY_PATH:+:}''$1/lib/ocaml/${ocaml.version}/site-lib/${name}-llvm-plugins/"
  '';

  nativeBuildInputs = [ which makeWrapper ];

  buildInputs = [ ocaml_oasis
                  llvm_38
                  utop ];

  propagatedBuildInputs = [ bitstring camlzip cmdliner core_kernel ezjsonm faillib fileutils ocaml_lwt ocamlgraph ocurl re uri zarith piqi
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

  doCheck = true;

  checkTarget = "check test";

  configureFlags = "--enable-everything --enable-tests ${disableIda} --with-llvm-config=${llvm_38}/bin/llvm-config";

  BAPBUILDFLAGS = "-j $(NIX_BUILD_CORES)";

  meta = with stdenv.lib; {
    description = "Platform for binary analysis. It is written in OCaml, but can be used from other languages.";
    homepage = https://github.com/BinaryAnalysisPlatform/bap/;
    maintainers = [ maintainers.maurer ];
    license = licenses.mit;
    broken = versionAtLeast ocaml.version "4.03";
  };
}
