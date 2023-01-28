{ stdenv, lib, fetchFromGitHub, perl, gmp, mpfr, ppl, ocaml, findlib, camlidl, mlgmpidl
, gnumake42
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-apron";
  version = "0.9.13";
  src = fetchFromGitHub {
    owner = "antoinemine";
    repo = "apron";
    rev = "v${version}";
    sha256 = "14ymjahqdxj26da8wik9d5dzlxn81b3z1iggdl7rn2nn06jy7lvy";
  };

  # fails with make 4.4
  nativeBuildInputs = [ ocaml findlib perl gnumake42 ];
  buildInputs = [ gmp mpfr ppl camlidl ];
  propagatedBuildInputs = [ mlgmpidl ];

  strictDeps = false;

  outputs = [ "out" "bin" "dev" ];

  configurePhase = ''
    runHook preConfigure
    ./configure -prefix $out
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
    runHook postConfigure
  '';

  postInstall = ''
    mkdir -p $dev/lib
    mv $out/lib/ocaml $dev/lib/
    mkdir -p $bin
    mv $out/bin $bin/
  '';

  meta = {
    license = lib.licenses.lgpl21;
    homepage = "http://apron.cri.ensmp.fr/library/";
    maintainers = [ lib.maintainers.vbgl ];
    description = "Numerical abstract domain library";
    inherit (ocaml.meta) platforms;
  };
}
