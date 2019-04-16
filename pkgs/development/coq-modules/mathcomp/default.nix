{ stdenv, fetchFromGitHub, coq, ncurses, which
, graphviz, withDoc ? false
}:

let param =

  if stdenv.lib.versionAtLeast coq.coq-version "8.7" then
  {
    version = "1.8.0";
    sha256 = "07l40is389ih8bi525gpqs3qp4yb2kl11r9c8ynk1ifpjzpnabwp";
  }
  else if stdenv.lib.versionAtLeast coq.coq-version "8.6" then
  {
    version = "1.7.0";
    sha256 = "0wnhj9nqpx2bw6n1l4i8jgrw3pjajvckvj3lr4vzjb3my2lbxdd1";
  }
  else if stdenv.lib.versionAtLeast coq.coq-version "8.5" then
  {
    version = "1.6.1";
    sha256 = "1ilw6vm4dlsdv9cd7kmf0vfrh2kkzr45wrqr8m37miy0byzr4p9i";
  }
  else throw "No version of math-comp is available for Coq ${coq.coq-version}";

in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-mathcomp-${version}";

  # used in ssreflect
  inherit (param) version;

  src = fetchFromGitHub {
    owner = "math-comp";
    repo = "math-comp";
    rev = "mathcomp-${param.version}";
    inherit (param) sha256;
  };

  nativeBuildInputs = stdenv.lib.optionals withDoc [ graphviz ];
  buildInputs = [ coq ncurses which ] ++ (with coq.ocamlPackages; [ ocaml findlib camlp5 ]);

  enableParallelBuilding = true;

  buildFlags = stdenv.lib.optionalString withDoc "doc";

  COQBIN = "${coq}/bin/";

  preBuild = ''
    patchShebangs etc/utils/ssrcoqdep || true
    cd mathcomp
  '';

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '' + stdenv.lib.optionalString withDoc ''
    make -f Makefile.coq install-doc DOCDIR=$out/share/coq/${coq.coq-version}/
  '';

  meta = with stdenv.lib; {
    homepage = http://ssr.msr-inria.inria.fr/;
    license = licenses.cecill-b;
    maintainers = [ maintainers.vbgl maintainers.jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: stdenv.lib.versionAtLeast v "8.5";
  };

}
