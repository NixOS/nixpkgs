{ stdenv, lib, fetchFromGitHub, perl, ocaml, findlib, camlidl, gmp, mpfr, bigarray-compat }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-mlgmpidl";
  version = "1.2.15";
  src = fetchFromGitHub {
    owner = "nberth";
    repo = "mlgmpidl";
    rev = version;
    sha256 = "sha256-85wy5eVWb5qdaa2lLDcfqlUTIY7vnN3nGMdxoj5BslU=";
  };

  nativeBuildInputs = [ perl ocaml findlib camlidl ];
  buildInputs = [ gmp mpfr ];
  propagatedBuildInputs = [ bigarray-compat ];

  strictDeps = true;

  prefixKey = "-prefix ";
  configureFlags = [
    "--gmp-prefix ${gmp.dev}"
    "--mpfr-prefix ${mpfr.dev}"
    "-disable-profiling"
  ];

  postConfigure = ''
    substituteInPlace Makefile --replace "/bin/rm" "rm"
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
  '';


  meta = {
    description = "OCaml interface to the GMP library";
    homepage = "https://www.inrialpes.fr/pop-art/people/bjeannet/mlxxxidl-forge/mlgmpidl/";
    license = lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
