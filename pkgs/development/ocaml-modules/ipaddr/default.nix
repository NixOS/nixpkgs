{stdenv, buildOcaml, fetchurl, sexplib_p4}:

buildOcaml rec {
  name = "ipaddr";
  version = "2.6.1";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-ipaddr/archive/${version}.tar.gz";
    sha256 = "7051013d8f58abff433187d70cd7ddd7a6b49a6fbe6cad1893f571f65b8ed3d0";
  };

  propagatedBuildInputs = [ sexplib_p4 ];

  configurePhase = ''
   ocaml setup.ml -configure --prefix $out
  '';

  buildPhase =  ''
  make build
  '';

  installPhase =  ''
  make install
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-ipaddr;
    description = "A library for manipulation of IP (and MAC) address representations ";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
