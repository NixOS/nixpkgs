{ stdenv, lib, fetchurl, buildDunePackage, ocaml, dune-configurator, pkg-config, cairo
, ApplicationServices }:

buildDunePackage rec {
  pname = "cairo2";
  version = "0.6.4";

  src = fetchurl {
    url = "https://github.com/Chris00/ocaml-cairo/releases/download/${version}/cairo2-${version}.tbz";
    sha256 = "sha256-QDVzUtcgXTpXNYVWQ4MMs0Xy24OP+dGaUyAYdg1GigU=";
  };

  minimalOCamlVersion = "4.02";
  useDune2 = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cairo dune-configurator ] ++ lib.optionals stdenv.isDarwin [ ApplicationServices ];

  doCheck = !(stdenv.isDarwin
  # https://github.com/Chris00/ocaml-cairo/issues/19
  || lib.versionAtLeast ocaml.version "4.10");

  meta = with lib; {
    homepage = "https://github.com/Chris00/ocaml-cairo";
    description = "Binding to Cairo, a 2D Vector Graphics Library";
    longDescription = ''
      This is a binding to Cairo, a 2D graphics library with support for
      multiple output devices. Currently supported output targets include
      the X Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.
    '';
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jirkamarsik vbgl ];
  };
}
