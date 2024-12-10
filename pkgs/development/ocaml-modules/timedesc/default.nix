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

buildDunePackage rec {
  pname = "timedesc";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/daypack-dev/timere/releases/download/timedesc-${version}/timedesc-${version}.tar.gz";
    hash = "sha256-NnnQpWOE1mt/F5lkWRPdDwpqXCUlcNi+Z5GE6YQQLK8=";
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
}
