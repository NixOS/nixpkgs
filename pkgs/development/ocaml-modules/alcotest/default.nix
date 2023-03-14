{ lib, buildDunePackage, fetchurl
, astring, cmdliner, fmt, re, stdlib-shims, uutf, ocaml-syntax-shims
}:

buildDunePackage rec {
  pname = "alcotest";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${version}/alcotest-${version}.tbz";
    sha256 = "sha256-/QD5ZoOVh0/zsdfvVm0U78Avp900Ej6yXVk1W+lLIyk=";
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
