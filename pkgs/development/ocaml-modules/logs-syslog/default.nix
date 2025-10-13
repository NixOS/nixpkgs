{
  lib,
  fetchurl,
  buildDunePackage,
  logs,
  syslog-message,
  ptime,
  version ? "0.5.0",
}:

buildDunePackage {
  pname = "logs-syslog";
  inherit version;
  src = fetchurl {
    url = "https://github.com/hannesm/logs-syslog/releases/download/v${version}/logs-syslog-${version}.tbz";
    hash = "sha256-rx7mksA8y1BCEisNTQwSsJaet42eR7tZ3gYzvCqrYNQ=";
  };

  propagatedBuildInputs = [
    logs
    syslog-message
    ptime
  ];

  meta = {
    description = "Logs reporter to syslog (UDP/TCP/TLS)";
    homepage = "https://github.com/hannesm/logs-syslog";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
