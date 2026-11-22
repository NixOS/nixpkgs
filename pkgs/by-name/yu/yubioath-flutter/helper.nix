{
  rustPlatform,
  pkg-config,
  udev,
  dbus,
  pcsclite,

  src,
  version,
  meta,
}:

rustPlatform.buildRustPackage {
  pname = "yubioath-flutter-helper";
  inherit src version meta;

  sourceRoot = "${src.name}/helper";

  cargoHash = "sha256-EDCidHMOwXzUv3YUZAL8gdtV3HyS9CLQzT4/D+YF2ss=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    udev
    dbus
    pcsclite
  ];

  postInstall = ''
    install -d $out/libexec/helper
    ln -fs $out/bin/authenticator-helper $out/libexec/helper/authenticator-helper
  '';
}
