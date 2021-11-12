{ libssh2, fetchurl }:

libssh2.overrideAttrs (attrs: rec {
  version = "1.10.0";
  src = fetchurl {
    url = with attrs; "${meta.homepage}/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-LWTpDz3tOUuR06LndMogOkF59prr7gMAPlpvpiHkHVE=";
  };
  patches = [];
})
