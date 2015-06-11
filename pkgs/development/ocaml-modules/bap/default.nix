{buildOcaml, fetchurl, camlp4, ocaml_oasis, bitstring, camlzip, cmdliner, cohttp, core_kernel, ezjsonm, faillib, fileutils, ocaml_lwt, ocamlgraph, ocurl, re, uri, zarith, piqi, piqi-ocaml, uuidm, clang, llvm_34, ulex, easy-format, xmlm, utop, which}:
 
buildOcaml rec {
  name = "bap";
  version = "0.9.8";
  src = fetchurl {
    url = "https://github.com/BinaryAnalysisPlatform/bap/archive/v${version}.tar.gz";    
    sha256 = "18lxl7svnqw5qcy7v07kw08207zc1z4ycqbs01hqhj9dyd9j9zh5";
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
                  ];

  installPhase = ''
  cat <<EOF > baptop
  #!/bin/bash
  export OCAMLPATH=`echo $OCAMLPATH`:`echo $OCAMLFIND_DESTDIR`
  exec `which utop` -require bap.top "\$@"
  EOF
  make install
  '';

  configureFlags = "--with-llvm-config llvm-config";
}
