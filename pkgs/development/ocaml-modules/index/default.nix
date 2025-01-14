{
  lib,
  fetchurl,
  buildDunePackage,
  repr,
  ppx_repr,
  fmt,
  logs,
  mtime,
  stdlib-shims,
  cmdliner,
  progress,
  semaphore-compat,
  optint,
  alcotest,
  crowbar,
  re,
  lru,
}:

buildDunePackage rec {
  pname = "index";
  version = "1.6.2";

  src = fetchurl {
    url = "https://github.com/mirage/index/releases/download/${version}/index-${version}.tbz";
    hash = "sha256-k4iDUJik7UTuztBw7YaFXASd8SqYMR1JgLm3JOyriGA=";
  };

  minimalOCamlVersion = "4.08";

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
    description = "Platform-agnostic multi-level index";
    homepage = "https://github.com/mirage/index";
    license = licenses.mit;
    maintainers = with maintainers; [ vbgl ];
  };
}
