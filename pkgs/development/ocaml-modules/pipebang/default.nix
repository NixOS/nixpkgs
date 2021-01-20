{lib, buildOcaml, fetchurl}:

buildOcaml rec {
  name = "pipebang";
  version = "113.00.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/pipebang/archive/${version}.tar.gz";
    sha256 = "0acm2y8wxvnapa248lkgm0vcc44hlwhrjxqkx1awjxzcmarnxhfk";
  };

  meta = with lib; {
    homepage = "https://github.com/janestreet/pipebang";
    description = "Syntax extension to transform x |! f into f x";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
