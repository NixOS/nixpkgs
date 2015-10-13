{ stdenv, buildOcaml, fetchzip, cmdliner, stringext }:

buildOcaml rec {
  name = "alcotest";
  version = "0.4.5";

  src = fetchzip {
    url = "https://github.com/mirage/alcotest/archive/${version}.tar.gz";
    sha256 = "1wcn9hkjf4cbnrz99w940qfjpi0lvd8v63yxwpnafkff871dwk6k";
  };

  propagatedBuildInputs = [ cmdliner stringext ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/alcotest;
    description = "A lightweight and colourful test framework";
    license = stdenv.lib.licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
