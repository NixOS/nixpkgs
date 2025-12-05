{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  astring,
  cmdliner,
  fmt,
  re,
  stdlib-shims,
  uutf,
  ocaml-syntax-shims,
}:

buildDunePackage (finalAttrs: {
  pname = "alcotest";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "alcotest";
    tag = finalAttrs.version;
    hash = "sha256-c5GmcB+VzpRkJ6yN9/KjzR8SxNQcgruC+dZ3NmU5WxI=";
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

  meta = {
    homepage = "https://github.com/mirage/alcotest";
    description = "Lightweight and colourful test framework";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ericbmerritt ];
  };
})
