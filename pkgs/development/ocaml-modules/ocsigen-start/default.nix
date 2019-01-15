{ stdenv, fetchFromGitHub, buildOcaml, ocsigen-toolkit, eliom, ocaml_pcre, pgocaml, macaque, safepass, yojson, ocsigen_deriving, ocsigen_server
, js_of_ocaml-camlp4
, resource-pooling
}:

buildOcaml rec
{
  name = "ocsigen-start";
  version = "1.4.0";

  buildInputs = [ eliom js_of_ocaml-camlp4 ];
  propagatedBuildInputs = [ pgocaml macaque safepass ocaml_pcre ocsigen-toolkit yojson ocsigen_deriving ocsigen_server resource-pooling ];

  patches = [ ./templates-dir.patch ];

  postPatch = ''
  substituteInPlace "src/os_db.ml" --replace "citext" "text"
  '';
  
  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = name;
    rev = version;
    sha256 = "1kicbw5cjb9gkfmfbqf6fiwbi0rzpqgk2lzd4v6nxaiyinxm73ff";
  };

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
