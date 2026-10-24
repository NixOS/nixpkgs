{
  lib,
  buildDunePackage,
  fetchurl,
  cstruct,
  fmt,
  logs,
  lwt,
  macaddr,
  metrics,
  mirage-net,
  mirage-solo5,
  ocaml-solo5,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-net-solo5";
  version = "0.8.1";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/mirage/mirage-net-solo5/releases/download/v${finalAttrs.version}/mirage-net-solo5-${finalAttrs.version}.tbz";
    hash = "sha256-dcjX56KZz4pxbPDpFlm40vkrdW0pwVW4y+9Ihiikx3o=";
  };

  nativeBuildInputs = [ ocaml-solo5 ];

  preBuild = ''
    cat > dune-workspace <<EOF
    (lang dune 3.0)
    (context (default (name solo5) (toolchain solo5)))
    EOF
  '';

  propagatedBuildInputs = [
    cstruct
    fmt
    logs
    lwt
    macaddr
    metrics
    mirage-net
    mirage-solo5
  ];

  meta = {
    description = "Solo5 implementation of MirageOS network interface";
    homepage = "https://github.com/mirage/mirage-net-solo5";
    changelog = "https://github.com/mirage/mirage-net-solo5/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.stepbrobd ];
    inherit (ocaml-solo5.meta) platforms;
  };
})
