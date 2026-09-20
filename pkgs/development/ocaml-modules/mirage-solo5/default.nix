{
  lib,
  buildDunePackage,
  fetchurl,
  bheap,
  duration,
  lwt,
  metrics,
  metrics-lwt,
  mirage-runtime,
  mirage-sleep,
  ocaml-solo5,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-solo5";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-solo5/releases/download/v${finalAttrs.version}/mirage-solo5-${finalAttrs.version}.tbz";
    hash = "sha256-iFzrIs5cfRF22r3tZpAnmr79LolCk4Pqxu5Xpz2XVIA=";
  };

  nativeBuildInputs = [ ocaml-solo5 ];

  preBuild = ''
    cat > dune-workspace <<EOF
    (lang dune 3.0)
    (context (default (name solo5) (toolchain solo5)))
    EOF
  '';

  propagatedBuildInputs = [
    bheap
    duration
    lwt
    metrics
    metrics-lwt
    mirage-runtime
    mirage-sleep
  ];

  meta = {
    description = "Solo5 core platform libraries for MirageOS";
    homepage = "https://github.com/mirage/mirage-solo5";
    changelog = "https://github.com/mirage/mirage-solo5/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.stepbrobd ];
    inherit (ocaml-solo5.meta) platforms;
  };
})
