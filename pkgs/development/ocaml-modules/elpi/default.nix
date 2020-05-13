{ stdenv, fetchzip, lib, sedutil, bash, fetchFromGitHub
, dune_2, ocaml, findlib, opaline, camlp5
, ppx_tools_versioned, ppxlib, ppx_deriving, re
, ocaml-migrate-parsetree, ppxfind
}:

stdenv.mkDerivation rec {
  pname = "elpi";
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "1.11.2";

   src = fetchzip {
     url = "https://github.com/LPCIC/elpi/releases/download/v${version}/elpi-v${version}.tbz";
     sha256 = "15hamy9ifr05kczadwh3yj2gmr12a9z1jwppmp5yrns0vykjbj76";
   };

  minimumOCamlVersion = "4.04";

  buildInputs = [ ocaml dune_2 findlib sedutil ppx_tools_versioned ];

  propagatedBuildInputs = [ camlp5 ppx_deriving re ];

  SHELL="${bash}/bin/bash";

  patchPhase = ''
    sed -e "s/SHELL:=/SHELL?=/" -i Makefile
  '';

  buildPhase = ''
    runHook preBuild
    make build DUNE_OPTS="-p ${pname}" ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    make test DUNE_OPTS="-p ${pname}" ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postCheck
  '';

  preInstall = ''
    make fix-elpi.install
  '';

  installPhase = ''
    runHook preInstall
    ${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR
    runHook postInstall
  '';

  meta = {
    description = "Embeddable λProlog Interpreter";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };

  # useDune2 = true;
}
