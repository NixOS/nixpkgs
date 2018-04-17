{stdenv, fetchgit, coq, ocamlPackages, python27}:

stdenv.mkDerivation rec {

  name = "coq-fiat-${coq.coq-version}-unstable-${version}";
  version = "2018-02-27";

  src = fetchgit {
    url = "https://github.com/mit-plv/fiat.git";
    rev = "253fc133397f73d6daed0b9518ca7ab5507a1cb0";
    sha256 = "0b5z7nz0cr1s7vy04s996dj0pd7ljqx6g5a8syh4hy2z87ijkjzd";
  };

  buildInputs = [ ocamlPackages.ocaml ocamlPackages.camlp5_transitional
                  ocamlPackages.findlib python27 ];
  propagatedBuildInputs = [ coq ];

  doCheck = false;

  enableParallelBuilding = true;
  buildPhase = "make -j$NIX_BUILD_CORES";

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/Fiat
    cp -pR src/* $COQLIB/user-contrib/Fiat
  '';

  meta = with stdenv.lib; {
    homepage = http://plv.csail.mit.edu/fiat/;
    description = "A library for the Coq proof assistant for synthesizing efficient correct-by-construction programs from declarative specifications";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" ];
  };
}
