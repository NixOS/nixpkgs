{stdenv, fetchurl, ocaml, camlp4, findlib, lwt, xenstore, libev}:

stdenv.mkDerivation {
  name = "ocaml-xenstore-clients-0.9.3";
  version = "0.9.3";

  src = fetchurl {
    url = "https://github.com/xapi-project/ocaml-xenstore-clients/archive/0.9.3/ocaml-xenstore-clients-0.9.3.tar.gz";
    sha256 = "04dizhfps72333554znsk2nw424cfbsjqakzifhpq851im2zd7my";
  };

  buildInputs = [ ocaml camlp4 findlib lwt xenstore libev ];

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install DESTDIR=$out
    '';

  meta = {
    homepage = https://github.com/xapi-project/ocaml-xenstore-clients;
    description = "Unix xenstore clients for OCaml";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
