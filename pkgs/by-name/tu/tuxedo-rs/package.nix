{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuxedo-rs";
  version = "0.3.2";

  # NOTE: This src is shared with tailor-gui.
  # When updating, the tailor-gui.cargoDeps hash needs to be updated.
  src = fetchFromGitHub {
    owner = "AaronErhardt";
    repo = "tuxedo-rs";
    rev = "tailor-v${finalAttrs.version}";
    hash = "sha256-Ma5HEZqtGVcqUOU7lkjUX/Thr0X4zbMWqIizZuC04xk=";
  };

  # Some of the tests are impure and rely on files in /etc/tailord
  doCheck = false;

  cargoHash = "sha256-jQoW4rwP/5q4PdEQ0ln/Hzn+XQcz5xI1LoWGFbuAGBo=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  postInstall = ''
    install -Dm444 tailord/com.tux.Tailor.conf -t $out/share/dbus-1/system.d
  '';

  meta = {
    description = "Rust utilities for interacting with hardware from TUXEDO Computers";
    longDescription = ''
      An alternative to the TUXEDO Control Center daemon.

      Contains the following binaries:
      - tailord: Daemon handling fan, keyboard and general HW support for Tuxedo laptops
      - tailor: CLI
    '';
    homepage = "https://github.com/AaronErhardt/tuxedo-rs";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      xaverdh
    ];
    platforms = lib.platforms.linux;
    mainProgram = "tailor";
  };
})
