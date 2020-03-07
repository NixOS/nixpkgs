{ stdenv, fetchFromGitHub, ocaml, findlib, ocsigen-toolkit, pgocaml_ppx, macaque, safepass, yojson
, cohttp-lwt-unix
, resource-pooling
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ocsigen-start-${version}";
  version = "2.16.1";

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ pgocaml_ppx safepass ocsigen-toolkit yojson resource-pooling cohttp-lwt-unix ];

  patches = [ ./templates-dir.patch ];

  postPatch = ''
  substituteInPlace "src/os_db.ml" --replace "citext" "text"
  '';

  createFindlibDestdir = true;
  
  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "ocsigen-start";
    rev = version;
    sha256 = "1pzpyrd3vbhc7zvzh6bv44793ikx5bglpd5p4wk5jj65v1w39jwd";
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
