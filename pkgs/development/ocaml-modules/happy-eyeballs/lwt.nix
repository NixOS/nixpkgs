{ lib, buildDunePackage, fetchurl
, domain-name, duration, fmt, ipaddr, logs, mtime, cmdliner_1_1, dns-client
, happy-eyeballs
}:


buildDunePackage rec {
  pname = "happy-eyeballs-lwt";

  minimalOCamlVersion = "4.08";
  inherit (happy-eyeballs) version src ;

  useDune2 = true;

  propagatedBuildInputs = [
    happy-eyeballs
    cmdliner_1_1
    domain-name
    duration
    fmt
    ipaddr
    logs
    dns-client
    mtime
  ];


  meta = {
    description = "Connecting to a remote host via IP version 4 or 6 using Lwt_unix";
    homepage = "https://github.com/roburio/happy-eyeballs";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
