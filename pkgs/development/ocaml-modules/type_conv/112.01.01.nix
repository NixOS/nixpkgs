{stdenv, fetchurl, buildOcaml}:

buildOcaml rec {
  minimumSupportedOcamlVersion = "4.02";

  name = "type_conv";
  version = "112.01.01";

  src = fetchurl {
    url = "https://github.com/janestreet/type_conv/archive/${version}.tar.gz";
    sha256 = "dbbc33b7ab420e8442d79ba4308ea6c0c16903b310d33525be18841159aa8855";
  };

  meta = {
    homepage = https://github.com/janestreet/type_conv/;
    description = "Support library for preprocessor type conversions";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ z77z ericbmerritt ];
  };
}
