{ stdenv, fetchurl, coq, ncurses, which
, graphviz, withDoc ? false
}:

let params =

  let param_1_7 = {
      version = "1.7.0";
      sha256 = "05zgyi4wmasi1rcyn5jq42w0bi9713q9m8dl1fdgl66nmacixh39";
  }; in

  {
    "8.5" =  {
      version = "1.6.1";
      sha256 = "1j9ylggjzrxz1i2hdl2yhsvmvy5z6l4rprwx7604401080p5sgjw";
    };

    "8.6" = param_1_7;
    "8.7" = param_1_7;
    "8.8" = param_1_7;
    "8.9" = param_1_7;

  };
  param = params."${coq.coq-version}";
in

stdenv.mkDerivation {
  name = "coq${coq.coq-version}-mathcomp-${param.version}";

  src = fetchurl {
    url = "https://github.com/math-comp/math-comp/archive/mathcomp-${param.version}.tar.gz";
    inherit (param) sha256;
  };

  nativeBuildInputs = stdenv.lib.optionals withDoc [ graphviz ];
  buildInputs = [ coq ncurses which ] ++ (with coq.ocamlPackages; [ ocaml findlib camlp5 ]);

  enableParallelBuilding = true;

  buildFlags = stdenv.lib.optionalString withDoc "doc";

  preBuild = ''
    patchShebangs etc/utils/ssrcoqdep || true
    cd mathcomp
    export COQBIN=${coq}/bin/
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
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };

}
