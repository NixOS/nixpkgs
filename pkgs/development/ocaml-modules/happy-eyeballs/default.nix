{
  lib,
  buildDunePackage,
  fetchurl,
  domain-name,
  duration,
  fmt,
  ipaddr,
  logs,
}:

buildDunePackage (finalAttrs: {
  pname = "happy-eyeballs";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/roburio/happy-eyeballs/releases/download/v${finalAttrs.version}/happy-eyeballs-${finalAttrs.version}.tbz";
    hash = "sha256-Ct4Vt44VZW0X/qk9CG5D9s7r5INjDGDM6sIIYn298ao=";
  };

  propagatedBuildInputs = [
    domain-name
    duration
    fmt
    ipaddr
    logs
  ];

  meta = {
    description = "Connecting to a remote host via IP version 4 or 6";
    homepage = "https://github.com/roburio/happy-eyeballs";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      vbgl
      ulrikstrid
    ];
  };
})
