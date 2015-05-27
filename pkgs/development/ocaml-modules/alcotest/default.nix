{stdenv, buildOcaml, fetchurl, ounit, re, cmdliner}:

buildOcaml rec {
  name = "alcotest";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/samoht/alcotest/archive/${version}.tar.gz";
    sha256 = "a0e6c9a33c59b206ecc949655fa6e17bdd1078c8b610b14d8f6f0f1b489b0b43";
  };

  propagatedBuildInputs = [ ounit re cmdliner ];

  meta = with stdenv.lib; {
    homepage = https://github.com/samoht/alcotest;
    description = "A lightweight and colourful test framework";
    license = stdenv.lib.licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
