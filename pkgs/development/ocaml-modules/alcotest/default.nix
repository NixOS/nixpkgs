{ lib, buildDunePackage, fetchurl
, astring, cmdliner, fmt, uuidm, re, stdlib-shims
}:

buildDunePackage rec {
  pname = "alcotest";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${version}/alcotest-${version}.tbz";
    sha256 = "1xlklxb83gamqbg8j5dzm5jk4mvcwkspxajh93p6vpw9ia1li1qc";
  };

  propagatedBuildInputs = [ astring cmdliner fmt uuidm re stdlib-shims ];

  meta = with lib; {
    homepage = "https://github.com/mirage/alcotest";
    description = "A lightweight and colourful test framework";
    license = licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
