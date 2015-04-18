{ocaml, findlib, stdenv, fetchurl, ocaml_sexplib}:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.12";
stdenv.mkDerivation {
  name = "ocaml-ipaddr-2.5.0";
  
  src = fetchurl {
    url = https://github.com/mirage/ocaml-ipaddr/archive/2.5.0.tar.gz;
    sha256 = "0zpslxzjs5zdw20j3jaf6fr0w2imnidhrzggmnvwp198r76aq917";
  };

  buildInputs = [ocaml findlib];
  propagatedBuildInputs = [ocaml_sexplib];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "An OCaml library for manipulation of IP (and MAC) address representations";
    license = licenses.isc;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms;
  };
  
}
