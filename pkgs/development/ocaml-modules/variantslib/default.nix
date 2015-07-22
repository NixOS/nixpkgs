{stdenv, buildOcaml, fetchurl, type_conv}:

buildOcaml rec {
  name = "variantslib";
  version = "109.15.03";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/variantslib/archive/${version}.tar.gz";
    sha256 = "a948dcdd4ca54786fe0646386b6e37a9db03bf276c6557ea374d82740bf18055";
  };

  propagatedBuildInputs = [ type_conv ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/variantslib;
    description = "OCaml variants as first class values";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
