{ stdenv, fetchurl, buildDunePackage, sexplib, ppx_sexp_conv }:

buildDunePackage rec {
  pname = "ipaddr";
  version = "2.8.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-${pname}/archive/${version}.tar.gz";
    sha256 = "1amb1pbm9ybpxy6190qygpj6nmbzzs2r6vx4xh5r6v89szx9rfxw";
  };

  propagatedBuildInputs = [ ppx_sexp_conv sexplib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-ipaddr;
    description = "A library for manipulation of IP (and MAC) address representations ";
    license = licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
