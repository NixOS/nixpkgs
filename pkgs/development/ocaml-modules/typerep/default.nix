{stdenv, buildOcaml, fetchurl, type_conv}:

buildOcaml rec {
  name = "typerep";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/typerep/archive/${version}.tar.gz";
    sha256 = "4f1ab611a00aaf774e9774b26b687233e0c70d91f684415a876f094a9969eada";
  };

  propagatedBuildInputs = [ type_conv ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/janestreet/typerep";
    description = "Runtime types for OCaml (beta version)";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };

}
