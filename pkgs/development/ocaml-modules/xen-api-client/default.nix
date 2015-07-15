{stdenv, fetchurl, ocaml, camlp4, cohttp, cstruct, findlib, lwt, ounit, rpc, uri, xmlm, libev}:

stdenv.mkDerivation {
  name = "ocaml-xen-api-client-0.9.7";
  version = "0.9.7";

  src = fetchurl {
    url = "https://github.com/xapi-project/xen-api-client/archive/0.9.7/xen-api-client-0.9.7.tar.gz";
    sha256 = "0zhgqj1raxmlxq6z2l5cwxhqkansk40j51jyn5piz9z9qvhad3lx";
  };

  buildInputs = [ ocaml camlp4 cohttp cstruct findlib lwt ounit rpc uri xmlm libev ];

  configurePhase = ''
    ocaml setup.ml -configure --disable-tests --enable-lwt
    '';

  buildPhase = ''
    make
    make doc
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install
    '';

  meta = {
    homepage = https://github.com/xapi-project/xen-api-client;
    description = "XenServer XenAPI Client Library for OCaml";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
