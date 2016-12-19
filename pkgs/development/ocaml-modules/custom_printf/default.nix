{stdenv, buildOcaml, fetchurl, type_conv, sexplib_p4, pa_ounit}:

buildOcaml rec {
  name = "custom_printf";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/custom_printf/archive/${version}.tar.gz";
    sha256 = "dad3aface92c53e8fbcc12cc9358c4767cb1cb09857d4819a10ed98eccaca8f9";
  };

  buildInputs = [ pa_ounit ];
  propagatedBuildInputs = [ type_conv sexplib_p4 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/custom_printf;
    description = "Syntax extension for printf format strings";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
