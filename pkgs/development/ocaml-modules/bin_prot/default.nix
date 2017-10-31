{stdenv, writeText, buildOcaml, fetchurl, type_conv}:

buildOcaml rec {
  name = "bin_prot";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/bin_prot/archive/${version}.tar.gz";
    sha256 = "dc0c978a825c7c123990af3317637c218f61079e6f35dc878260651084f1adb4";
  };

  propagatedBuildInputs = [ type_conv ];

  hasSharedObjects = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/bin_prot;
    description = "Binary protocol generator ";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
