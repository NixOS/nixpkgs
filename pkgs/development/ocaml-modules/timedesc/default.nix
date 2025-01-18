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
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/daypack-dev/timere/releases/download/timedesc-${version}/timedesc-${version}.tar.gz";
    hash = "sha256-nEachJymJC8TP/Ha2rOFU3n09rxVlIZYmgQnYiNCiHE=";
  };

  sourceRoot = ".";

  propagatedBuildInputs = [
    angstrom
    ptime
    seq
    timedesc-tzdb
    timedesc-tzlocal
  ];

  meta = with lib; {
    description = "OCaml date time handling library";
    homepage = "https://github.com/daypack-dev/timere";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
