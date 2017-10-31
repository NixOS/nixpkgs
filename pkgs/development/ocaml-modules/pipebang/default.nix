{stdenv, buildOcaml, fetchurl}:

buildOcaml rec {
  name = "pipebang";
  version = "110.01.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/pipebang/archive/${version}.tar.gz";
    sha256 = "a8858d9607c15cdf0a775196be060c8d91de724fc80a347d7a76ef1d38329096";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/pipebang;
    description = "Syntax extension to transform x |! f into f x";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
