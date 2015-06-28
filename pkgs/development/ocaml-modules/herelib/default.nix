{stdenv, buildOcaml, fetchurl}:

buildOcaml rec {
  version = "109.35.02";
  name = "herelib";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/herelib/archive/${version}.tar.gz";
    sha256 = "7f8394169cb63f6d41e91c9affa1b8ec240d5f6e9dfeda3fbb611df521d4b05a";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/herelib;
    description = "Syntax extension for inserting the current location";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
