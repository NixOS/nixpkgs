{
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

  checkInputs = [
    ppx_windtrap
    thumper
    windtrap
  ];

  # The job-control tests inspect a running process with ps(1) on platforms
  # without /proc. In the Darwin build sandbox ps(1) is not on PATH, and
  # macOS refuses its `time` field without an entitlement, so those tests
  # cannot pass there.
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = mosaic.meta // {
    description = "Fast, modern terminal toolkit for OCaml";
  };
}
