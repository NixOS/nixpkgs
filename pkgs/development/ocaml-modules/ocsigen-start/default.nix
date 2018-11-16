{ stdenv, fetchurl, buildOcaml, ocsigen-toolkit, eliom, ocaml_pcre, pgocaml, macaque, safepass, yojson, ocsigen_deriving, ocsigen_server
, js_of_ocaml-camlp4
}:

buildOcaml rec
{
  name = "ocsigen-start";
  version = "1.1.0";

  buildInputs = [ eliom js_of_ocaml-camlp4 ];
  propagatedBuildInputs = [ pgocaml macaque safepass ocaml_pcre ocsigen-toolkit yojson ocsigen_deriving ocsigen_server ];

  patches = [ ./templates-dir.patch ];

  postPatch = ''
  substituteInPlace "src/os_db.ml" --replace "citext" "text"
  '';
  
  src = fetchurl {
    url = "https://github.com/ocsigen/${name}/archive/${version}.tar.gz";
    sha256 = "09cw6qzcld0m1qm66mbjg9gw8l6dynpw3fzhm3kfx5ldh0afgvjq";
  };

  createFindlibDestdir = true;

  meta = {
    homepage = http://ocsigen.org/ocsigen-start;
    description = "Eliom application skeleton";
    longDescription =''
     An Eliom application skeleton, ready to use to build your own application with users, (pre)registration, notifications, etc.
      '';
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };

}
