{stdenv, buildOcaml, fetchurl, type_conv, camlp4}:

buildOcaml rec {
  minimumSupportedOcamlVersion = "4.02";
  name = "sexplib";
  version = "112.24.01";

  src = fetchurl {
    url = "https://github.com/janestreet/sexplib/archive/${version}.tar.gz";
    sha256 = "5f776aee295cc51c952aecd4b74b52dd2b850c665cc25b3d69bc42014d3ba073";
  };

  propagatedBuildInputs = [ type_conv camlp4 ];

  meta = with stdenv.lib; {
    homepage = https://ocaml.janestreet.com/;
    description = "Library for serializing OCaml values to and from S-expressions";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
