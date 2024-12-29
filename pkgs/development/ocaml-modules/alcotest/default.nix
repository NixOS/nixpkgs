{ lib, buildDunePackage, fetchurl, fetchpatch
, astring, cmdliner, fmt, re, stdlib-shims, uutf, ocaml-syntax-shims
}:

buildDunePackage rec {
  pname = "alcotest";
  version = "1.7.0";

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${version}/alcotest-${version}.tbz";
    hash = "sha256-gSus2zS0XoiZXgfXMGvasvckee8ZlmN/HV0fQWZ5At8=";
  };

  # Fix tests with OCaml 5.2
  patches = fetchpatch {
    url = "https://github.com/mirage/alcotest/commit/aa437168b258db97680021116af176c55e1bd53b.patch";
    hash = "sha256-cytuJFg4Mft47LsAEcz2zvzyy1wNzMdeLK+cjaFANpo=";
  };

  nativeBuildInputs = [ ocaml-syntax-shims ];

  propagatedBuildInputs = [ astring cmdliner fmt re stdlib-shims uutf ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/alcotest";
    description = "Lightweight and colourful test framework";
    license = licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
