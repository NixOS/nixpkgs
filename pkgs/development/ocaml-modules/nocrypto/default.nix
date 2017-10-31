{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, opam, topkg
, cpuid, ocb-stubblr
, cstruct, zarith, ocaml_oasis, ppx_sexp_conv, sexplib
, lwt ? null
}:

with stdenv.lib;
let withLwt = lwt != null; in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-nocrypto-${version}";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner  = "mirleft";
    repo   = "ocaml-nocrypto";
    rev    = "v${version}";
    sha256 = "0nhnlpbqh3mf9y2cxivlvfb70yfbdpvg6jslzq64xblpgjyg443p";
  };

  buildInputs = [ ocaml ocaml_oasis findlib ocamlbuild topkg opam cpuid ocb-stubblr
    ppx_sexp_conv ];
  propagatedBuildInputs = [ cstruct zarith sexplib ] ++ optional withLwt lwt;

  buildPhase = ''
    LD_LIBRARY_PATH=${cpuid}/lib/ocaml/${ocaml.version}/site-lib/stubslibs/ \
    ${topkg.buildPhase} --with-lwt ${boolToString withLwt}
  '';
  inherit (topkg) installPhase;

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/mirleft/ocaml-nocrypto;
    description = "Simplest possible crypto to support TLS";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
