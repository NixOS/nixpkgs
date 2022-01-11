{ lib, fetchzip, stdenvNoCC, writeText }:

let
  version = "20211124";
in stdenvNoCC.mkDerivation {
  name = "iana-etc-${version}";
  src = fetchzip {
    url = "https://github.com/Mic92/iana-etc/releases/download/${version}/iana-etc-${version}.tar.gz";
    sha256 = "sha256-4mM/ZeGd91e1AklGHFK5UB4llg9IgCo9DKcM0iXcBls=";
  };

  installPhase = ''
    install -D -m0644 -t $out/etc services protocols
  '';

  setupHook = writeText "setup-hook" ''
    export NIX_ETC_PROTOCOLS=@out@/etc/protocols
    export NIX_ETC_SERVICES=@out@/etc/services
  '';

  meta = with lib; {
    homepage = "https://github.com/Mic92/iana-etc";
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
