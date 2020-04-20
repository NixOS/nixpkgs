{ stdenv, fetchFromGitHub, buildDunePackage
, ppx_sexp_conv, sexplib
, astring, ipaddr, macaddr, uri,
}:

buildDunePackage rec {
  pname = "conduit";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-conduit";
    rev = "v${version}";
    sha256 = "1qzamqcmf9ywz04bkwrv17mz9j6zq2w9h1xmnjvp11pnwrs2xq8l";
  };

  buildInputs = [ ppx_sexp_conv ];
  propagatedBuildInputs = [ astring ipaddr macaddr sexplib uri ];

  meta = {
    description = "Network connection library for TCP and SSL";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ alexfmpe vbgl ];
    inherit (src.meta) homepage;
  };
}
