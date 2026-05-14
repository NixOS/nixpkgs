{
  lib,
  fetchurl,
  buildDunePackage,
  astring,
  fmt,
  logs,
  lwt,
}:

buildDunePackage (finalAttrs: {
  pname = "irmin-watcher";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/mirage/irmin-watcher/releases/download/${finalAttrs.version}/irmin-watcher-${finalAttrs.version}.tbz";
    hash = "sha256-vq4kwaz4QUG9x0fGEbQMAuDGjlT3/6lm8xiXTUqJmZM=";
  };

  propagatedBuildInputs = [
    astring
    fmt
    logs
    lwt
  ];

  meta = {
    homepage = "https://github.com/mirage/irmin-watcher";
    description = "Portable Irmin watch backends using FSevents or Inotify";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

})
