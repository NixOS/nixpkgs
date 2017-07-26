{ stdenv, fetchurl, buildOcaml, ocsigen-toolkit, eliom, ocaml_pcre, pgocaml, macaque, safepass, yojson, ojquery, magick, ocsigen_deriving, ocsigen_server }:

buildOcaml rec
{
  name = "ocsigen-start";
  version = "1.0.0";

  buildInputs = [ eliom ];
  propagatedBuildInputs = [ pgocaml macaque safepass ocaml_pcre ocsigen-toolkit yojson ojquery ocsigen_deriving ocsigen_server magick ];

  patches = [ ./templates-dir.patch ];

  postPatch = ''
  substituteInPlace "src/os_db.ml" --replace "citext" "text"
  '';
  
  src = fetchurl {
    url = "https://github.com/ocsigen/${name}/archive/${version}.tar.gz";
    sha256 = "0npc2iq39ixci6ly0fssklv07zqi5cfa1adad4hm8dbzjawkqqll";
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
