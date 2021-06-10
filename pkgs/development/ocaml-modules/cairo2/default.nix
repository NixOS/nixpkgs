{ stdenv, lib, fetchurl, buildDunePackage, ocaml, dune-configurator, pkg-config, cairo }:

buildDunePackage rec {
  pname = "cairo2";
  version = "0.6.2";

  src = fetchurl {
    url = "https://github.com/Chris00/ocaml-cairo/releases/download/${version}/cairo2-${version}.tbz";
    sha256 = "1bhhcrr74gc7a9qykcmi4zi0xy3xpp6wcw0v2vx088v64n9gbcvb";
  };

  useDune2 = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
    dune-configurator
  ];

  doCheck = !(stdenv.isDarwin
  # https://github.com/Chris00/ocaml-cairo/issues/19
  || lib.versionAtLeast ocaml.version "4.10");

  meta = with lib; {
    description = "Binding to Cairo, a 2D Vector Graphics Library";
    longDescription = ''
      This is a binding to Cairo, a 2D graphics library with support for
      multiple output devices. Currently supported output targets include
      the X Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.
    '';
    homepage = "https://github.com/Chris00/ocaml-cairo";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jirkamarsik vbgl ];
  };
}
