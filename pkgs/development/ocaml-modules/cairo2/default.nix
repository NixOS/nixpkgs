{
  stdenv,
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  dune-configurator,
  pkg-config,
  cairo,
}:

buildDunePackage (finalAttrs: {
  pname = "cairo2";
  version = "0.6.5";

  src = fetchurl {
    url = "https://github.com/Chris00/ocaml-cairo/releases/download/${finalAttrs.version}/cairo2-${finalAttrs.version}.tbz";
    hash = "sha256-JdxByUNtmrz1bKrZoQWUT/c0YEG4zGoqZUq4hItlc3I=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cairo
    dune-configurator
  ];

  doCheck =
    !(
      stdenv.hostPlatform.isDarwin
      # https://github.com/Chris00/ocaml-cairo/issues/19
      || lib.versionAtLeast ocaml.version "4.10"
    );

  meta = {
    homepage = "https://github.com/Chris00/ocaml-cairo";
    description = "Binding to Cairo, a 2D Vector Graphics Library";
    longDescription = ''
      This is a binding to Cairo, a 2D graphics library with support for
      multiple output devices. Currently supported output targets include
      the X Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.
    '';
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [
      jirkamarsik
      vbgl
    ];
  };
})
