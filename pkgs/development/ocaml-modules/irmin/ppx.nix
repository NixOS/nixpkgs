{ lib, fetchurl, buildDunePackage, ppxlib, ocaml-syntax-shims }:

buildDunePackage rec {
  pname = "ppx_irmin";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    sha256 = "0gzw918b661qkvd140hilww9jsc49rxsxz1k4iihyvikjn202km4";
  };

  minimumOCamlVersion = "4.06";

  useDune2 = true;

  buildInputs = [ ocaml-syntax-shims ];
  propagatedBuildInputs = [ ppxlib ];

  # tests depend on irmin, would create mutual dependency
  # opt to test irmin instead of ppx_irmin
  doCheck = false;

  meta = {
    homepage = "https://irmin.org/";
    description = "PPX deriver for Irmin generics";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
