{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  jheiling-extras,
  jheiling-js,
  lib,
}:
build-idris-package {
  pname = "electron";
  version = "2016-03-07";

  idrisDeps = [
    contrib
    jheiling-extras
    jheiling-js
  ];

  src = fetchFromGitHub {
    owner = "jheiling";
    repo = "idris-electron";
    rev = "f0e86f52b8e5a546a2bf714709b659c1c0b04395";
    hash = "sha256-lsf1CjwQ28iqUgXb4+6rVhQrmiRlLgygAfRft6U/6uY=";
  };

  meta = {
    description = "Electron bindings for Idris";
    homepage = "https://github.com/jheiling/idris-electron";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
