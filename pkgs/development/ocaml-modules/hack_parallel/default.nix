{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  core,
  core_unix ? null,
  pkg-config,
  sqlite,
}:
buildDunePackage rec {
  pname = "hack_parallel";
  version = "1.0.1";
  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "rvantonder";
    repo = "hack_parallel";
    rev = version;
    sha256 = "0qjlkw35r4q2cm0n2x0i73zvx1xgrp6axaia2nm8zxpm49mid629";
  };

  patches = [ ./hack_parallel.patch ];

  postPatch = ''
    substituteInPlace src/third-party/hack_core/hack_caml.ml --replace 'include Pervasives' ""
    substituteInPlace \
      src/interface/hack_parallel_intf.mli \
      src/procs/worker.ml \
      src/third-party/hack_core/hack_core_list.ml \
      src/third-party/hack_core/hack_result.ml* \
      src/utils/collections/myMap.ml \
      src/utils/daemon.ml* \
      src/utils/exit_status.ml \
      src/utils/hack_path.ml \
      src/utils/measure.ml \
      src/utils/timeout.ml \
      --replace Pervasives. Stdlib.
    substituteInPlace src/utils/sys_utils.ml --replace String.create Bytes.create
  '';

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [
    core
    core_unix
    sqlite
  ];

  meta = {
    description = "Core parallel and shared memory library used by Hack, Flow, and Pyre";
    license = lib.licenses.mit;
    homepage = "https://github.com/rvantonder/hack_parallel";
  };
}
