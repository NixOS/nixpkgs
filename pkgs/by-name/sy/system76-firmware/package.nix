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
rustPlatform.buildRustPackage rec {
  pname = "system76-firmware";
  # Check Makefile when updating, make sure postInstall matches make install
  version = "1.0.74";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-firmware";
    rev = version;
    sha256 = "sha256-lgBEzOxTmVAksZ7yo7dIUzP6Z8KKmUpEIDEpU7CL69Y=";
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

  cargoHash = "sha256-Xztvc8t3w6a5vf0zPU6roFIIgGLjebWmw18UaU1BdhA=";

  # Purposefully don't install systemd unit file, that's for NixOS
  postInstall = ''
    install -D -m -0644 data/system76-firmware-daemon.conf $out/etc/dbus-1/system.d/system76-firmware-daemon.conf

    for bin in $out/bin/system76-firmware-*
    do
      wrapProgram $bin --prefix PATH : "${efibootmgr}/bin"
    done
  '';

  meta = with lib; {
    description = "Tools for managing firmware updates for system76 devices";
    homepage = "https://github.com/pop-os/system76-firmware";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ shlevy ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
