{stdenv, fetchurl, buildOcaml}:

buildOcaml rec {
  minimumSupportedOcamlVersion = "4.02";

  name = "type_conv";
  version = "113.00.02";

  src = fetchurl {
    url = "https://github.com/janestreet/type_conv/archive/${version}.tar.gz";
    sha256 = "1718yl2q8zandrs4xqffkfmssfld1iz62dzcqdm925735c1x01fk";
  };

  meta = {
    homepage = https://github.com/janestreet/type_conv/;
    description = "Support library for preprocessor type conversions";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ z77z ericbmerritt ];
  };
}
