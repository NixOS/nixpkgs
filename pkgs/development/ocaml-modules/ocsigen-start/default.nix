{ stdenv, fetchFromGitHub, ocaml, findlib, camlp4, ocsigen-toolkit, pgocaml, macaque, safepass, yojson
, js_of_ocaml-camlp4, lwt_camlp4
, cohttp-lwt-unix
, resource-pooling
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ocsigen-start-${version}";
  version = "2.7.0";

  buildInputs = [ ocaml findlib js_of_ocaml-camlp4 lwt_camlp4 ];
  propagatedBuildInputs = [ pgocaml macaque safepass ocsigen-toolkit yojson resource-pooling cohttp-lwt-unix camlp4 ];

  patches = [ ./templates-dir.patch ];

  postPatch = ''
  substituteInPlace "src/os_db.ml" --replace "citext" "text"
  '';

  createFindlibDestdir = true;
  
  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigen-start";
    rev = version;
    sha256 = "1kp9g679xnff2ybwsicnc9c203hi9ri1ijbpp6221b2sj6zxf2wc";
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
