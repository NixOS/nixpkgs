{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuxedo-rs";
  version = "0.3.1";

  # NOTE: This src is shared with tailor-gui.
  # When updating, the tailor-gui.cargoDeps hash needs to be updated.
  src = fetchFromGitHub {
    owner = "AaronErhardt";
    repo = "tuxedo-rs";
    rev = "tailor-v${finalAttrs.version}";
    hash = "sha256-+NzwUs8TZsA0us9hI1UmEKdiOo9IqTRmTOHs4xmC7MY=";
  };

  # Some of the tests are impure and rely on files in /etc/tailord
  doCheck = false;

  cargoHash = "sha256-EkTLL7thZ/bBpY7TwfEsPOjJxzQ3vpxDi+sYPNAK6og=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstall = ''
    install -Dm444 tailord/com.tux.Tailor.conf -t $out/share/dbus-1/system.d
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Rust utilities for interacting with hardware from TUXEDO Computers";
    longDescription = ''
      An alternative to the TUXEDO Control Center daemon.

      Contains the following binaries:
      - tailord: Daemon handling fan, keyboard and general HW support for Tuxedo laptops
      - tailor: CLI
    '';
    homepage = "https://github.com/AaronErhardt/tuxedo-rs";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      mrcjkb
      xaverdh
    ];
    platforms = lib.platforms.linux;
=======
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      mrcjkb
      xaverdh
    ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "tailor";
  };
})
