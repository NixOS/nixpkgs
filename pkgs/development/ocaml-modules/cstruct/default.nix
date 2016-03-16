{stdenv, writeText, fetchurl, ocaml, ocplib-endian, sexplib, findlib,
 async ? null, lwt ? null, camlp4}:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01";

stdenv.mkDerivation {
  name = "ocaml-cstruct-1.6.0";

  src = fetchurl {
    url = https://github.com/mirage/ocaml-cstruct/archive/v1.6.0.tar.gz;
    sha256 = "0f90a1b7a03091cf22a3ccb11a0cce03b6500f064ad3766b5ed81418ac008ece";
  };

  configureFlags = stdenv.lib.strings.concatStringsSep " " ((if lwt != null then ["--enable-lwt"] else []) ++
                                          (if async != null then ["--enable-async"] else []));
  buildInputs = [ocaml findlib camlp4];
  propagatedBuildInputs = [ocplib-endian sexplib lwt async];

  createFindlibDestdir = true;
  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-cstruct;
    description = "Map OCaml arrays onto C-like structs";
    license = stdenv.lib.licenses.isc;
    maintainers = [ maintainers.vbgl maintainers.ericbmerritt ];
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
  };
}
