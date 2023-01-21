{ lib, fetchurl, buildDunePackage
, logs, lwt, mirage-clock, mirage-profile, ptime
, alcotest, stdlib-shims
}:

buildDunePackage rec {
  pname = "mirage-logs";
  version = "1.2.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-logs/releases/download/v${version}/mirage-logs-v${version}.tbz";
    sha256 = "0h0amzjxy067jljscib7fvw5q8k0adqa8m86affha9hq5jsh07a1";
  };

  propagatedBuildInputs = [ logs lwt mirage-clock mirage-profile ptime stdlib-shims ];

  doCheck = true;
  nativeCheckInputs = [ alcotest ];

  meta = {
    description = "A reporter for the Logs library that writes log messages to stderr, using a Mirage `CLOCK` to add timestamps";
    homepage = "https://github.com/mirage/mirage-logs";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
