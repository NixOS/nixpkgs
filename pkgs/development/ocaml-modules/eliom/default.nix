{ stdenv, fetchurl, ocaml, findlib, which, ocsigen_server, ocsigen_deriving,
  js_of_ocaml, ocaml_react, ocaml_lwt, calendar, cryptokit, tyxml,
  ipaddr, ocamlnet, ocaml_ssl, ocaml_pcre, ocaml_optcomp,
  reactivedata, opam}:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4";

stdenv.mkDerivation rec
{
  pname = "eliom";
  version = "4.2.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = https://github.com/ocsigen/eliom/archive/4.2.tar.gz;
    sha256 = "0gbqzgn6xgpq6irz2sfr92qj3hjcwl45wy0inc4ps5r15nvq1l9h";
  };

  patches = [ ./camlp4.patch ];

  buildInputs = [ocaml which ocsigen_server findlib ocsigen_deriving
                 js_of_ocaml ocaml_optcomp opam];

  propagatedBuildInputs = [ ocaml_lwt reactivedata tyxml ipaddr
                            calendar cryptokit ocamlnet ocaml_react ocaml_ssl
                            ocaml_pcre ];

  installPhase =
  let ocamlVersion = (builtins.parseDrvName (ocaml.name)).version;
  in
  ''opam-installer --script --prefix=$out ${pname}.install > install.sh
    sh install.sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${ocamlVersion}/site-lib/
  '';

  createFindlibDestdir = true;

  meta = {
    homepage = http://ocsigen.org/eliom/;
    description = "Ocaml Framework for programming Web sites and client/server Web applications";

    longDescription =''Eliom is a framework for programming Web sites
    and client/server Web applications. It introduces new concepts to
    simplify programming common behaviours and uses advanced static
    typing features of OCaml to check many properties of the Web site
    at compile time. If you want to write a Web application, Eliom
    makes possible to write the whole application as a single program
    (client and server parts). A syntax extension is used to
    distinguish both parts and the client side is compiled to JS using
    Ocsigen Js_of_ocaml.'';

    license = stdenv.lib.licenses.lgpl21;

    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;

    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };
}
