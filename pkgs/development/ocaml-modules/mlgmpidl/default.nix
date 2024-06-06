{ stdenv, lib, fetchFromGitHub, perl, ocaml, findlib, camlidl, gmp, mpfr, bigarray-compat }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-mlgmpidl";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "nberth";
    repo = "mlgmpidl";
    rev = version;
    hash = "sha256-ZmSDKZiHko8MCeIuZL53HjupfwO6PAm8QOCc9O3xJOk=";
  };

  nativeBuildInputs = [ perl ocaml findlib camlidl ];
  buildInputs = [ gmp mpfr ];
  propagatedBuildInputs = [ bigarray-compat ];

  strictDeps = true;

  prefixKey = "-prefix ";

  postConfigure = ''
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
