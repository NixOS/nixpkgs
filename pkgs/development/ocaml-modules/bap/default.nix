{stdenv, buildOcaml, fetchgit, camlp4, ocaml_oasis, bitstring, camlzip, cmdliner, cohttp, core_kernel, ezjsonm, faillib, fileutils, ocaml_lwt, ocamlgraph, ocurl, re, uri, zarith, piqi, piqi-ocaml, uuidm, clang, llvm_34, ulex, easy-format, xmlm, utop, which, makeWrapper}:
 
buildOcaml rec {
  name = "bap";
  version = "8d1a7c";
  src = fetchgit {
    url = "https://github.com/BinaryAnalysisPlatform/bap.git";    
    rev = "8d1a7ca938320802c784adfa54ff5d851d5251d3";
    sha256 = "04n50n22sbslijdcjlv0h1z5fwwxsj08bdw5n9lxrrfm6fakfpdv";
  };

  createFindlibDestdir = true;

  buildInputs = [ camlp4 ocaml_oasis bitstring camlzip cmdliner cohttp
                  core_kernel ezjsonm faillib fileutils ocaml_lwt
                  ocamlgraph ocurl re uri zarith piqi piqi-ocaml uuidm
                  clang llvm_34                  
                  #rdeps
                  utop
                  #build tricks
                  which
                  makeWrapper
                  ];

  installPhase = ''
  cat <<EOF > baptop
  #!/bin/bash
  export OCAMLPATH=`echo $OCAMLPATH`:`echo $OCAMLFIND_DESTDIR`
  exec `which utop` -require bap.top "\$@"
  EOF
  make install
  wrapProgram $out/bin/bapbuild --set OCAMLPATH `echo $OCAMLPATH`:`echo $OCAMLFIND_DESTDIR` --set PATH `echo $PATH`
  '';

  configureFlags = "--with-llvm-config llvm-config";

  meta = with stdenv.lib; {
    description = "Platform for binary analysis. It is written in OCaml, but can be used from other languages.";
    homepage = https://github.com/BinaryAnalysisPlatform/bap/;
    license = licenses.mit;
  };
}
