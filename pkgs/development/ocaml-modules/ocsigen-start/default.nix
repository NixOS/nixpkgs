{ stdenv, fetchFromGitHub, ocaml, findlib, ocsigen-toolkit, eliom, ocaml_pcre, pgocaml, macaque, safepass, yojson, ocsigen_deriving, ocsigen_server
, js_of_ocaml-camlp4, lwt_camlp4
, resource-pooling
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ocsigen-start-${version}";
  version = "1.8.0";

  buildInputs = [ ocaml findlib eliom js_of_ocaml-camlp4 lwt_camlp4 ];
  propagatedBuildInputs = [ pgocaml macaque safepass ocaml_pcre ocsigen-toolkit yojson ocsigen_deriving ocsigen_server resource-pooling ];

  patches = [ ./templates-dir.patch ];

  postPatch = ''
  substituteInPlace "src/os_db.ml" --replace "citext" "text"
  '';

  createFindlibDestdir = true;
  
  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigen-start";
    rev = version;
    sha256 = "0h5gp06vxy6jpppz1x840gyf9viiy7lic7spx7fxldpy2jpv058s";
  };

  meta = {
    homepage = http://ocsigen.org/ocsigen-start;
    description = "Eliom application skeleton";
    longDescription =''
     An Eliom application skeleton, ready to use to build your own application with users, (pre)registration, notifications, etc.
      '';
    license = stdenv.lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.gal_bolle ];
  };

}
