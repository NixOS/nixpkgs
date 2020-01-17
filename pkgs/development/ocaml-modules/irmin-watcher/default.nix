{ lib, fetchurl, buildDunePackage
, astring, fmt, logs, ocaml_lwt
}:

buildDunePackage rec {
  pname = "irmin-watcher";
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/mirage/irmin-watcher/releases/download/${version}/irmin-watcher-${version}.tbz";
    sha256 = "00d4ph4jbsw6adp3zqdrwi099hfcf7p1xzi0685qr7bgcmandjfv";
  };

  propagatedBuildInputs = [ astring fmt logs ocaml_lwt ];

  meta = {
    homepage = "https://github.com/mirage/irmin-watcher";
    description = "Portable Irmin watch backends using FSevents or Inotify";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
