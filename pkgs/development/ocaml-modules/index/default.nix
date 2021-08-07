{ lib, fetchurl, buildDunePackage
, repr, ppx_repr, fmt, logs, mtime, stdlib-shims
, cmdliner, progress, semaphore-compat, optint
, alcotest, crowbar, re
}:

buildDunePackage rec {
  pname = "index";
  version = "1.4.0";

  src = fetchurl {
    url = "https://github.com/mirage/index/releases/download/${version}/index-${version}.tbz";
    sha256 = "13xd858c50fs651p1y8x70323ff0gzbf6zgc0a25f6xh3rsmkn4c";
  };

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  buildInputs = [
    stdlib-shims
  ];
  propagatedBuildInputs = [
    cmdliner
    fmt
    logs
    mtime
    ppx_repr
    progress
    repr
    semaphore-compat
    optint
  ];

  checkInputs = [
    alcotest
    crowbar
    re
  ];
  doCheck = true;

  meta = with lib; {
    description = "A platform-agnostic multi-level index";
    homepage = "https://github.com/mirage/index";
    license = licenses.mit;
    maintainers = with maintainers; [ vbgl ];
  };
}
