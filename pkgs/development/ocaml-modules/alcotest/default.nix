{ lib, buildDunePackage, fetchurl
, astring, cmdliner, fmt, uuidm, re, stdlib-shims, uutf
}:

buildDunePackage rec {
  pname = "alcotest";
  version = "1.4.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${version}/alcotest-mirage-${version}.tbz";
    sha256 = "sha256:1h9yp44snb6sgm5g1x3wg4gwjscic7i56jf0j8jr07355pxwrami";
  };

  propagatedBuildInputs = [ astring cmdliner fmt uuidm re stdlib-shims uutf ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/alcotest";
    description = "A lightweight and colourful test framework";
    license = licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
