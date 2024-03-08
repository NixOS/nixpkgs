{ lib, buildDunePackage, fetchurl
, astring, cmdliner, fmt, re, stdlib-shims, uutf, ocaml-syntax-shims
}:

buildDunePackage rec {
  pname = "alcotest";
  version = "1.7.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${version}/alcotest-${version}.tbz";
    hash = "sha256-gSus2zS0XoiZXgfXMGvasvckee8ZlmN/HV0fQWZ5At8=";
  };

  nativeBuildInputs = [ ocaml-syntax-shims ];

  propagatedBuildInputs = [ astring cmdliner fmt re stdlib-shims uutf ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/alcotest";
    description = "A lightweight and colourful test framework";
    license = licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
