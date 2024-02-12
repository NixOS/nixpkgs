{ lib, fetchurl, buildDunePackage
, astring, fmt, logs, ocaml_lwt
}:

buildDunePackage rec {
  pname = "irmin-watcher";
  version = "0.5.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/irmin-watcher/releases/download/${version}/irmin-watcher-${version}.tbz";
    sha256 = "sha256-vq4kwaz4QUG9x0fGEbQMAuDGjlT3/6lm8xiXTUqJmZM=";
  };

  propagatedBuildInputs = [ astring fmt logs ocaml_lwt ];

  meta = {
    homepage = "https://github.com/mirage/irmin-watcher";
    description = "Portable Irmin watch backends using FSevents or Inotify";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
