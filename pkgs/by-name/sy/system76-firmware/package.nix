{
  rustPlatform,
  lib,
  fetchFromGitHub,
  xz,
  pkg-config,
  openssl,
  dbus,
  efibootmgr,
  makeWrapper,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "system76-firmware";
  # Check Makefile when updating, make sure postInstall matches make install
  version = "1.0.76";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-firmware";
    rev = finalAttrs.version;
    sha256 = "sha256-WODPJ9uW81hNOuXF1OfBcI4ByXi6lKEFt4mN6qd5i0Q=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    xz
    openssl
    dbus
  ];

  cargoBuildFlags = [ "--workspace" ];

  cargoHash = "sha256-UTc4z2ulhwefQQtudkTq3GO8YygPXcBlrxIYURX2jYc=";

  # Purposefully don't install systemd unit file, that's for NixOS
  postInstall = ''
    install -D -m -0644 data/system76-firmware-daemon.conf $out/etc/dbus-1/system.d/system76-firmware-daemon.conf

    for bin in $out/bin/system76-firmware-*
    do
      wrapProgram $bin --prefix PATH : "${efibootmgr}/bin"
    done
  '';

  meta = {
    description = "Tools for managing firmware updates for system76 devices";
    homepage = "https://github.com/pop-os/system76-firmware";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ shlevy ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
