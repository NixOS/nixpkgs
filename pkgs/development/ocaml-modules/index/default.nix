{ lib, fetchurl, buildDunePackage
, repr, ppx_repr, fmt, logs, mtime, stdlib-shims
, cmdliner, progress, semaphore-compat
, alcotest, crowbar, re
}:

buildDunePackage rec {
  pname = "index";
  version = "1.3.0";

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/index/releases/download/${version}/index-${version}.tbz";
    sha256 = "00qwhwg79scs5bgp8nbppv06qs9yhicf686q7lh64ngh0642iz6n";
  };

  buildInputs = [ stdlib-shims ];
  propagatedBuildInputs = [
    fmt logs mtime repr ppx_repr cmdliner progress semaphore-compat
  ];

  doCheck = true;
  checkInputs = [ alcotest crowbar re ];

  meta = {
    homepage = "https://github.com/mirage/index";
    description = "A platform-agnostic multi-level index";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
