{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, uutf, lwt }:

stdenv.mkDerivation rec {
  pname = "markup";
  version = "0.7.4";
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchzip {
    url = "http://github.com/aantron/markup.ml/archive/${version}.tar.gz";
    sha256 = "1hchlqzsy9pax91gcdmxzakfm22fbvhxzwyzpvz8fqkx4372zs37";
    };

  buildInputs = [ ocaml findlib ocamlbuild ];

  installPhase = "make ocamlfind-install";
  
  propagatedBuildInputs = [uutf lwt];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/aantron/markup.ml/;
    description = "A pair of best-effort parsers implementing the HTML5 and XML specifications";
    license = licenses.bsd2;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      gal_bolle
      ];
  };

}
