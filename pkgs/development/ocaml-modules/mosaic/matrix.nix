{
  lib,
  stdenv,
  buildDunePackage,
  mosaic,
  ppx_windtrap,
  thumper,
  windtrap,
}:

buildDunePackage {
  pname = "matrix";
  inherit (mosaic) version src;

  minimalOCamlVersion = "5.4";

  # These tests read the process state with ps(1) on macOS, but the ps from
  # adv_cmds is not entitled to read the CPU time of other processes
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i \
      -e '/test "SIGTSTP stops the job" test_sigtstp_stops_the_job;/d' \
      -e '/test "continued in the background, it stops again"/{N;d;}' \
      packages/matrix/test/test_runtime_pty.ml
  '';

  checkInputs = [
    ppx_windtrap
    thumper
    windtrap
  ];

  doCheck = true;

  meta = mosaic.meta // {
    description = "Fast, modern terminal toolkit for OCaml";
  };
}
