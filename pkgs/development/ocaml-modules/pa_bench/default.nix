{lib, buildOcaml, fetchurl, type_conv, pa_ounit}:

buildOcaml rec {
  name = "pa_bench";
  version = "113.00.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/pa_bench/archive/${version}.tar.gz";
    sha256 = "1cd6291gdnk6h8ziclg6x3if8z5xy67nfz9gx8sx4k2cwv0j29k5";
  };

  buildInputs = [ pa_ounit ];
  propagatedBuildInputs = [ type_conv ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/pa_bench";
    description = "Syntax extension for inline benchmarks";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
