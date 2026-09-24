{
  lib,
  fetchurl,
  buildDunePackage,
  angstrom,
  ptime,
  seq,
  timedesc-tzdb,
  timedesc-tzlocal,
}:

buildDunePackage (finalAttrs: {
  pname = "timedesc";
  version = "3.1.2";

  src = fetchurl {
    url = "https://github.com/daypack-dev/timere/releases/download/timedesc-${finalAttrs.version}/timedesc-${finalAttrs.version}.tar.gz";
    hash = "sha256-hXdijGY0qu+pLR2XtK/KL9gXvCstbZedo1379lqA1r0=";
  };

  sourceRoot = ".";

  propagatedBuildInputs = [
    angstrom
    ptime
    seq
    timedesc-tzdb
    timedesc-tzlocal
  ];

  meta = {
    description = "OCaml date time handling library";
    homepage = "https://github.com/daypack-dev/timere";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
