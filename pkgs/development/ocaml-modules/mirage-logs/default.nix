{ lib, fetchurl, buildDunePackage
, logs, lwt, mirage-clock, ptime
, alcotest
}:

buildDunePackage rec {
  pname = "mirage-logs";
  version = "1.3.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-logs/releases/download/v${version}/mirage-logs-${version}.tbz";
    hash = "sha256-c1YQIutqp58TRz+a9Vd/69FCv0jnGRvFnei9BtSbOxA=";
  };

  propagatedBuildInputs = [ logs lwt mirage-clock ptime ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "A reporter for the Logs library that writes log messages to stderr, using a Mirage `CLOCK` to add timestamps";
    homepage = "https://github.com/mirage/mirage-logs";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
