{stdenv, buildOcaml, fetchurl, ounit}:

buildOcaml rec {
  name = "pa_ounit";
  version = "112.24.00";

  src = fetchurl {
    url = "https://github.com/janestreet/pa_ounit/archive/${version}.tar.gz";
    sha256 = "fa04e72fe1db41e6dc64f9707cf5705cb9b957aa93265120c875c808eb9b9b96";
  };

  propagatedBuildInputs = [ ounit ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/pa_ounit;
    description = "OCaml inline testing";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
