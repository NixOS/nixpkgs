{ stdenv, fetchFromGitHub, coq, ncurses, which
, graphviz, mathcomp, withDoc ? false
}:

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-ssreflect-${version}";

  inherit (mathcomp) src version meta;

  nativeBuildInputs = stdenv.lib.optionals withDoc [ graphviz ];
  buildInputs = [ coq ncurses which ] ++ (with coq.ocamlPackages; [ ocaml findlib camlp5 ]);

  enableParallelBuilding = true;

  COQBIN = "${coq}/bin/";

  preBuild = ''
    patchShebangs etc/utils/ssrcoqdep || true
    cd mathcomp/ssreflect
  '';

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  postInstall = stdenv.lib.optionalString withDoc ''
    mkdir -p $out/share/doc/coq/${coq.coq-version}/user-contrib/mathcomp/ssreflect/
    cp -r html $out/share/doc/coq/${coq.coq-version}/user-contrib/mathcomp/ssreflect/
  '';

  passthru.compatibleCoqVersions = mathcomp.compatibleCoqVersions;
}
