{
  lib,
  fetchFromGitHub,
  fetchpatch,
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

  # tailord 0.3.1 detects only one of the two fans on the InfinityBook Pro AMD
  # Gen9 and Gen10, so the second fan stays idle. Both fixes are merged
  # upstream but not released yet.
  patches = [
    # https://github.com/AaronErhardt/tuxedo-rs/pull/184
    (fetchpatch {
      url = "https://github.com/AaronErhardt/tuxedo-rs/commit/43c10db8c7796bd0533c2ceb10fe8adaa5ba8b2b.patch";
      hash = "sha256-5k2RrfgW0eFxOUJgQ5Y1qYujnJVBDFNDDP9NLd9pppQ=";
    })
    # https://github.com/AaronErhardt/tuxedo-rs/pull/185
    (fetchpatch {
      url = "https://github.com/AaronErhardt/tuxedo-rs/commit/bfadc2e6cfd4b12dd7c14009d121262ea4b48f5d.patch";
      includes = [ "tuxedo_ioctl/*" ];
      hash = "sha256-+F4I2lG1WuRuA2wnC/kff31Th2CM/6EfnUkqMsbK4+g=";
    })
  ];

  # Some of the tests are impure and rely on files in /etc/tailord
  doCheck = false;

  cargoHash = "sha256-EkTLL7thZ/bBpY7TwfEsPOjJxzQ3vpxDi+sYPNAK6og=";

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
