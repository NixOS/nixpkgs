{ lib, fetchurl, buildDunePackage
, repr, ppx_repr, fmt, logs, mtime, stdlib-shims
, cmdliner, progress, semaphore-compat, optint
, alcotest, crowbar, re, lru
}:

buildDunePackage rec {
  pname = "index";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/mirage/index/releases/download/${version}/index-${version}.tbz";
    sha256 = "sha256:150mcsh8vj2hapfnxbjmacanjy4avrv8yk1lyaxmqj3fpmn1y32y";
  };

  minimalOCamlVersion = "4.08";
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
    lru
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
