{stdenv, buildOcaml, fetchFromGitHub, writeText,
 ocaml, ocplib-endian, sexplib_p4, findlib, ounit, camlp4,
 async_p4  ? null, lwt     ? null, ppx_tools ? null,
 withAsync ? true, withLwt ? true, withPpx   ? true}:

with stdenv.lib;
assert withAsync -> async_p4 != null;
assert withLwt -> lwt != null;
assert withPpx -> ppx_tools != null;

buildOcaml rec {
  name = "cstruct";
  version = "2.3.0";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-cstruct";
    rev = "v${version}";
    sha256 = "19spsgkry41dhsbm6ij71kws90bqp7wiggc6lsqdl43xxvbgdmys";
  };

  configureFlags = [ "--enable-tests" ] ++
                   optional withLwt [ "--enable-lwt" ] ++
                   optional withAsync [ "--enable-async" ] ++
                   optional withPpx ["--enable-ppx"];
  configurePhase = "./configure --prefix $out $configureFlags";

  buildInputs = [ ocaml findlib camlp4 ounit ];
  propagatedBuildInputs = [ocplib-endian sexplib_p4 ] ++
                          optional withPpx ppx_tools ++
                          optional withAsync async_p4 ++
                          optional withLwt lwt;

  doCheck = true;
  checkTarget = "test";

  createFindlibDestdir = true;
  dontStrip = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-cstruct;
    description = "Map OCaml arrays onto C-like structs";
    license = stdenv.lib.licenses.isc;
    maintainers = [ maintainers.vbgl maintainers.ericbmerritt ];
    platforms = ocaml.meta.platforms or [];
  };
}
