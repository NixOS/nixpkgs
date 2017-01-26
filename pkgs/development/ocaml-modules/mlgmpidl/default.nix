{ stdenv, fetchFromGitHub, ocaml, findlib, camlidl, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-mlgmpidl-${version}";
  version = "1.2.4";
  src = fetchFromGitHub {
    owner = "nberth";
    repo = "mlgmpidl";
    rev = version;
    sha256 = "09f9rk2bavhb7cdwjpibjf8bcjk59z85ac9dr8nvks1s842dp65s";
  };

  buildInputs = [ gmp mpfr ocaml findlib camlidl ];

  configurePhase = ''
    cp Makefile.config.model Makefile.config
    sed -i Makefile.config \
      -e 's|^MLGMPIDL_PREFIX.*$|MLGMPIDL_PREFIX = $out|' \
      -e 's|^GMP_PREFIX.*$|GMP_PREFIX = ${gmp.dev}|' \
      -e 's|^MPFR_PREFIX.*$|MPFR_PREFIX = ${mpfr.dev}|' \
      -e 's|^CAMLIDL_DIR.*$|CAMLIDL_DIR = ${camlidl}/lib/ocaml/${ocaml.version}/site-lib/camlidl|'
    echo HAS_NATIVE_PLUGINS = 1 >> Makefile.config
    sed -i Makefile \
      -e 's|^	/bin/rm |	rm |'
  '';

  createFindlibDestdir = true;

  meta = {
    description = "OCaml interface to the GMP library";
    homepage = https://www.inrialpes.fr/pop-art/people/bjeannet/mlxxxidl-forge/mlgmpidl/;
    license = stdenv.lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
