{
  lib,
  buildDunePackage,
  fetchurl,
  astring,
  cmdliner,
  fmt,
  re,
  stdlib-shims,
  uutf,
  ocaml-syntax-shims,
}:

buildDunePackage rec {
  pname = "alcotest";
  version = "1.9.1";

  src = fetchurl {
    url = "https://github.com/mirage/alcotest/releases/download/${version}/alcotest-${version}.tbz";
    hash = "sha256-HinDtB1DKQYhBbcj39o6/4a4zvXnx1ANDkkfxf145II=";
  };

  nativeBuildInputs = [ ocaml-syntax-shims ];

  propagatedBuildInputs = [
    astring
    cmdliner
    fmt
    re
    stdlib-shims
    uutf
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/alcotest";
    description = "Lightweight and colourful test framework";
    license = licenses.isc;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
