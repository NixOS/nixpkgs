{ stdenv, fetchzip, ocaml, findlib, dune, ssl, lwt }:

stdenv.mkDerivation rec {
  version = "1.1.2";
  name = "ocaml${ocaml.version}-lwt_ssl-${version}";

  src = fetchzip {
    url = "https://github.com/aantron/lwt_ssl/archive/${version}.tar.gz";
    sha256 = "1q0an3djqjxv83v3iswi7m81braqx93kcrcwrxwmf6jzhdm4pn15";
  };

  buildInputs = [ ocaml findlib dune ];
  propagatedBuildInputs = [ ssl lwt ];

  inherit (dune) installPhase;

  meta = {
    homepage = "https://github.com/aantron/lwt_ssl";
    description = "OpenSSL binding with concurrent I/O";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
