{stdenv, fetchurl, forkexecd, ocaml, camlp4, findlib, rpc, stdext, uri, re, cohttp, message-switch, xcp-inventory }:

stdenv.mkDerivation {
  name = "ocaml-tapctl-0.9.2";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/xapi-project/tapctl/archive/v0.9.2/ocaml-tapctl-0.9.2.tar.gz";
    sha256 = "0f0czz6609m77c2r5ibp1x48k4swkxvh20lr9ck31nx9y25rfr83";
  };

  buildInputs = [ ocaml camlp4 findlib uri re cohttp message-switch xcp-inventory ];

  propagatedBuildInputs = [ forkexecd rpc stdext ];

  configurePhase = ''
    ./configure
    '';

  buildPhase = ''
    make
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install
    '';

  meta = {
    homepage = https://github.com/xapi-project/tapctl;
    description = "Manipulate running tapdisk instances";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
