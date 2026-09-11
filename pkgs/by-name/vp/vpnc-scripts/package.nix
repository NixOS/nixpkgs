{
  lib,
  stdenv,
  fetchgit,
  coreutils,
  gawk,
  gnugrep,
  iproute2,
  makeWrapper,
  net-tools,
  openresolv,
  systemd,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation {
  pname = "vpnc-scripts";
  version = "unstable-2026-06-29";

  src = fetchgit {
    url = "https://gitlab.com/openconnect/vpnc-scripts.git";
    rev = "ce9e961bd0f6b867e1c7c35f78f6fb973f6ff101";
    hash = "sha256-Gbu+UCw6uSXH5pGpzLx9mc8D1/tpRNwfF5h5QdEBbYE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp vpnc-script $out/bin
  '';

  preFixup = ''
    substituteInPlace $out/bin/vpnc-script \
      --replace "which" "type -P"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $out/bin/vpnc-script \
      --replace "/sbin/resolvconf" "${openresolv}/bin/resolvconf"
  ''
  + lib.optionalString withSystemd ''
    substituteInPlace $out/bin/vpnc-script \
      --replace "/usr/bin/resolvectl" "${systemd}/bin/resolvectl"
  ''
  + ''
    wrapProgram $out/bin/vpnc-script \
      --prefix PATH : "${
        lib.makeBinPath (
          [
            net-tools
            gawk
            coreutils
            gnugrep
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            openresolv
            iproute2
          ]
        )
      }"
  '';

  meta = {
    homepage = "https://www.infradead.org/openconnect/";
    description = "Script for vpnc to configure the network routing and name service";
    mainProgram = "vpnc-script";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ jerith666 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
